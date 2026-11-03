import pandas as pd
from sqlalchemy import create_engine

engine = create_engine("postgresql+psycopg2:///vize")

ut = pd.read_json("data/raw/utterances.jsonl", lines=True)
conv = pd.read_json("data/raw/conversations.jsonl", lines=True)
sv = pd.read_json("data/raw/survey.jsonl", lines=True)

conv = conv[["conversation_id", "conversation_turns", "generated_datetime"]]
r = ut.merge(conv, on="conversation_id", how="left")
assert len(r) == len(ut)

ratings = pd.DataFrame({
    "id": r["utterance_id"],
    "conversation_id": r["conversation_id"],
    "rater_id": r["user_id"],
    "conversation_type": r["conversation_type"],
    "turn": r["turn"],
    "within_turn_id": r["within_turn_id"],
    "model_name": r["model_name"],
    "score": r["score"],
    "score_1_5": (r["score"] - 1) // 20 + 1,
    "is_empty": r["model_response"].eq("EMPTY STRING"),
    "conversation_turns": r["conversation_turns"],
    "rated_at": pd.to_datetime(r["generated_datetime"]),
})

raters = sv[["user_id", "lm_familiarity", "lm_frequency_use",
             "lm_direct_use", "num_completed_conversations"]].rename(
    columns={"user_id": "rater_id"})

ratings.to_csv("data/processed/ratings.csv", index=False)
raters.to_csv("data/processed/raters.csv", index=False)
ratings.to_sql("ratings", engine, if_exists="replace", index=False, chunksize=5000)
raters.to_sql("raters", engine, if_exists="replace", index=False)
print("ratings", len(ratings), "raters", len(raters))

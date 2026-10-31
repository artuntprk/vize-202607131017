import pandas as pd
from sqlalchemy import create_engine

engine = create_engine("postgresql+psycopg2:///vize")

def load(dosya, tablo, kolonlar=None):
    df = pd.read_json(f"data/raw/{dosya}.jsonl", lines=True)
    if kolonlar:
        df = df[kolonlar]
    df.to_sql(tablo, engine, if_exists="replace", index=False, chunksize=5000)
    print(tablo, len(df), "satir yuklendi")

load("utterances", "utterances")
load("conversations", "conversations", [
    "conversation_id", "user_id", "conversation_type", "opening_prompt",
    "conversation_turns", "open_feedback", "generated_datetime",
    "timing_duration_s", "timing_duration_mins", "included_in_balanced_subset"])
load("survey", "survey", [
    "user_id", "survey_only", "num_completed_conversations", "lm_familiarity",
    "lm_indirect_use", "lm_direct_use", "lm_frequency_use", "age", "education",
    "english_proficiency", "generated_datetime", "timing_duration_s",
    "timing_duration_mins"])

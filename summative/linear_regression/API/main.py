from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
import pickle
import pandas as pd

app = FastAPI(title="Insurance Regression Prediction API")

# Simple Get endpoint


@app.get("/")
def home():
    return {"message": "Insurance Prediction API is running 🚀"}


# CORS (optional)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load model pipeline
with open("model.pkl", "rb") as f:
    pipeline = pickle.load(f)

model = pipeline["model"]
scaler = pipeline["scaler"]
encoder = pipeline["encoder"]
feature_columns = pipeline["feature_columns"]


# Request format
class PredictRequest(BaseModel):
    age: int
    bmi: float
    smoker: str  # "yes" or "no"
    region: str  # northeast, northwest, southwest, southeast


@app.post("/predict")
def predict(payload: PredictRequest):
    # Convert smoker to numeric like in training
    smoker_map = {"yes": 1, "no": 0}
    if payload.smoker.lower() not in smoker_map:
        raise HTTPException(
            status_code=400, detail="smoker must be 'yes' or 'no'")

    smoker_val = smoker_map[payload.smoker.lower()]

    # Build a dataframe BEFORE encoding
    df = pd.DataFrame([{
        "age": payload.age,
        "bmi": payload.bmi,
        "smoker": smoker_val,
        "region": payload.region.lower()
    }])

    # One-hot encode region using the trained encoder
    try:
        region_encoded = encoder.transform(df[["region"]])
    except:
        raise HTTPException(
            status_code=400, detail="Invalid region. Use northeast/northwest/southeast/southwest")

    region_df = pd.DataFrame(
        region_encoded,
        columns=encoder.get_feature_names_out(["region"])
    )

    # Combine with original (drop region)
    df = pd.concat([df.drop(columns=["region"]), region_df], axis=1)

    # Reorder columns exactly like training
    df = df.reindex(columns=feature_columns, fill_value=0)

    # Scale using the saved scaler
    X_scaled = scaler.transform(df)

    # Predict
    prediction = model.predict(X_scaled)[0]

    return {"predicted_charges": float(prediction)}

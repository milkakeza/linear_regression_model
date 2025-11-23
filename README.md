# **Medical Insurance Cost Prediction — Linear Regression Project**

## **Mission**

My mission is to leverage data-driven insights to help users estimate their medical insurance costs more accurately. By analyzing real demographic and lifestyle factors, this model empowers individuals to make informed financial decisions about their healthcare plans.



## **Dataset Description**

**Dataset:** Medical Insurance Cost Prediction Dataset
**Source:** Kaggle (Medical Insurance Dataset)
**Rows:** 2772 | **Features:** Age, BMI, Children, Smoker, Region, Sex, Charges

### **Feature Summary**

* **Numerical:**

  * Age
  * BMI
  * Charges (Target Variable)
  * Children (dropped during feature engineering)

* **Categorical (Encoded):**

  * Smoker (yes/no → 1/0)
  * Region (one-hot encoded: northwest, northeast, southeast, southwest)
  * Sex (dropped during feature engineering)

### **Why This Dataset?**

* It contains **rich volume and variety** suitable for regression.
* Strong correlations: **smoking and BMI heavily influence medical costs**.
* Ideal for comparing linear vs non-linear models (Decision Tree, Random Forest).



## **API Endpoint**

A production-ready FastAPI service used to make real-time insurance cost predictions.

### ✅ **Live Swagger Documentation**

🔗 **[https://linear-regression-model-wng5.onrender.com/docs](https://linear-regression-model-wng5.onrender.com/docs)**

⚠️ *Note:*
Since Render uses a free plan, the API may take **30–50 seconds to wake up** after inactivity.



## **Demo Video**

🎥 **Demo Video Link:** *([Click Here](https://youtu.be/QcDnIq__Oqo))*
The video includes:

* Running the Flutter mobile app
* Making a prediction
* Testing the API in Swagger UI
* Explaining model performance and selection
* Showing the Jupyter notebook



## **Running the API Locally**

### **Navigate to API directory**

```bash
cd summative/API
```

### **Install dependencies**

```bash
pip install -r requirements.txt
```

### **Run using uvicorn**

```bash
uvicorn main:app --reload
```

### **Local Swagger UI**

[http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)



## **Flutter Mobile App Setup**

### **Requirements**

* Flutter SDK installed
* Android Emulator / iOS Simulator
* Stable internet connection

### **Run the Mobile App**

```bash
cd summative/FlutterApp
flutter pub get
flutter run
```

### **API URL Configuration**

In **main.dart**, set:

```dart
static String get apiBaseUrl {
  return 'https://linear-regression-model-wng5.onrender.com';
}
```

This ensures all predictions come from the deployed model on Render.



## **Summary of Machine Learning Models**

Three models were trained and compared:

| Model                 | R² Score                   | MAE      | MSE    | Notes                                           |
| --------------------- | -------------------------- | -------- | ------ | ----------------------------------------------- |
| **Linear Regression** | ~0.72                      | High     | High   | Underfits, misses non-linear patterns           |
| **SGD Regression**    | ~0.72                      | High     | High   | Similar to Linear Regression; stable but simple |
| **Random Forest**     | ~0.93                      | Very Low | Low    | Excellent non-linear performance                |
| **Decision Tree**     | **~0.94 (Selected Model)** | Lowest   | Lowest | Simple, fast, great performance                 |

### **Why Decision Tree Was Selected**

* Performs **almost as well as Random Forest** but with:

  * Lower complexity
  * Faster inference
  * Lightweight model for mobile API usage
* Captures **non-linear jumps**, especially due to smoking and BMI.

### **Saved Model**

The final model (`model.pkl`) includes:

* Trained Decision Tree model
* StandardScaler
* OneHotEncoder
* Feature column order



## **How to Use the API (Example)**

Send a POST request:

```
POST /predict
```

### **Body Example**

```json
{
  "age": 25,
  "bmi": 28.5,
  "smoker": "yes",
  "region": "southwest"
}
```

### **Response**

```json
{
  "predicted_charges": 35147.52848
}
```



# *✅You're All Set*

# **Author**
Milka Keza ISINGIZWE
ALU-Software Engineering Major Student

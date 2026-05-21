# 🌾 Saksham Edge

**Saksham Edge** is an enterprise-grade Field Force Intelligence application built natively for Android using **Kotlin** and **Jetpack Compose**. It was developed as part of the Syngenta IITM Hackathon 2026 to empower agricultural field representatives with actionable, offline-first insights.

Originally conceptualized in Flutter, this project was fully re-architected into Native Android to leverage deep system-level optimizations, robust offline local databases, and a state-of-the-art Jetpack Compose UI.

---

## ✨ Key Features

*   **⚡ 100% Offline Capable**: Built on top of Android's `Room` SQLite engine, the app pre-loads an asset-bundled database of 4,000+ real-world retailers. It requires absolutely no internet connection to query, sort, or update retailer intelligence in the field.
*   **🗺️ Interactive Offline Mapping**: Integrates `osmdroid` to render real-world territorial maps and retailer markers, plotting points completely offline.
*   **🧠 Explainable AI (XAI / LIME)**: An advanced "Next Best Action" (NBA) engine powered by an intuitive LIME (Local Interpretable Model-agnostic Explanations) UI. It doesn't just tell representatives *what* to pitch, it shows them *why* (e.g., +60% Satellite NDVI crop stress, +30% low stock).
*   **📸 Edge Vision ML (Anomaly Scanner)**: A simulated on-device TinyML integration that allows reps to snap photos of retail shelves. The app locally processes the image to detect anomalies (like Competitor Promotions) and instantly updates database priority scoring.
*   **🎤 Voice UI (Indic Integration)**: A beautiful, animated bottom-sheet interface simulating a Bhashini-powered Indic voice assistant, allowing hands-free field insights.

---

## 🛠️ Technology Stack

*   **Language**: Kotlin (v2.2.10)
*   **UI Toolkit**: Jetpack Compose (Material 3)
*   **Architecture**: MVVM (Model-View-ViewModel), StateFlow, Coroutines
*   **Database**: Room (SQLite) with KSP (Kotlin Symbol Processing)
*   **Map Rendering**: osmdroid
*   **Data Processing**: Python (Used in build-time to aggregate 35MB of raw CSV datasets into a highly optimized, pre-packaged `.db` asset).

---

## 📦 Setup & Installation

1.  **Clone the Repository**
    ```bash
    git clone https://github.com/Namangoel1904/Saksham-Edge.git
    ```

2.  **Open in Android Studio**
    *   Open Android Studio (Koala or newer recommended).
    *   Select **File -> Open** and choose the `Saksham-Edge` folder.

3.  **Sync Gradle**
    *   Allow Android Studio to sync the Gradle build files. It will automatically download Jetpack Compose, Room, and OSMDroid dependencies.

4.  **Run the App**
    *   Select an emulator or a physical device (API Level 24+) from the configuration dropdown.
    *   Click **Run** (Shift + F10).
    *   *Note: Because the database is pre-packaged as an asset, the app will instantly boot up with all 4,000 realistic retailers populated without parsing lag.*

---

## 📂 Project Structure

*   `app/src/main/java/.../beingnotified`: Contains the core Kotlin MVVM architecture.
    *   `data/`: Room Database configurations, Entities, and DAOs.
    *   `ui/screens/`: Jetpack Compose UI Screens (Home, Map, Detail, Voice).
    *   `ui/theme/`: Enterprise color palettes and typography.
*   `app/src/main/assets/databases/`: The pre-compiled `field_force_db.db` containing aggregated datasets.
*   `data/`: Raw CSV datasets (Hackathon provided).
*   `generate_db.py`: Python pre-processor script used to aggregate the raw CSVs into the asset SQLite database.

---

## 🛡️ License & Confidentiality

Developed for the **Syngenta IITM Hackathon 2026**. 
*Data utilized within this application has been anonymized according to the competition's privacy guidelines.*

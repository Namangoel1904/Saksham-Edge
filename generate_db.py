import sqlite3
import csv
import os
import random
from datetime import datetime

DB_PATH = "field_force_db.db"

def main():
    if os.path.exists(DB_PATH):
        os.remove(DB_PATH)
        
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS retailers (
            id TEXT PRIMARY KEY NOT NULL,
            name TEXT NOT NULL,
            lat REAL NOT NULL,
            lng REAL NOT NULL,
            inventoryLevel TEXT NOT NULL,
            priorityScore INTEGER NOT NULL,
            lastVisited TEXT NOT NULL
        )
    """)
    
    # 1. Generate random visit dates (retailer_visit_log doesn't link to retailer_id directly)
    print("Skipping visit log parsing, will generate random dates...")
                
    # 2. Parse inventory sum for the latest week per retailer
    inventory = {}
    print("Parsing inventory...")
    with open("data/retailer_inventory_weekly.csv", "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        retailer_weekly_sum = {}
        retailer_max_week = {}
        for row in reader:
            r_id = row["retailer_id"]
            w_date = row["week_end_date"]
            qty_str = row["sku_qty"]
            if not qty_str.isdigit(): continue
            qty = int(qty_str)
            
            if r_id not in retailer_max_week or w_date > retailer_max_week[r_id]:
                retailer_max_week[r_id] = w_date
                retailer_weekly_sum[r_id] = qty
            elif w_date == retailer_max_week[r_id]:
                retailer_weekly_sum[r_id] += qty

    # 3. Parse retailers and insert
    print("Parsing retailers and generating DB...")
    base_lat = 20.0
    base_lng = 75.0
    
    insert_count = 0
    with open("data/retailers.csv", "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            r_id = row["retailer_id"]
            tehsil = row.get("tehsil", "").strip()
            if not tehsil: tehsil = row.get("district", "Retailer").strip()
            
            name = f"{tehsil} Outlet #{r_id}"
            
            # Random scatter around Central India (Maharashtra/MP)
            lat = base_lat + (random.random() * 6.0 - 3.0)
            lng = base_lng + (random.random() * 6.0 - 3.0)
            
            qty = retailer_weekly_sum.get(r_id, 100)
            if qty < 50:
                inv_level = "Low"
            elif qty < 200:
                inv_level = "Medium"
            else:
                inv_level = "High"
                
            from datetime import timedelta
            random_days = random.randint(1, 90)
            last_visit_dt = datetime(2026, 4, 15) - timedelta(days=random_days)
            last_visit = last_visit_dt.strftime("%Y-%m-%d")
            
            # Calculate priority
            score = 50
            if inv_level == "Low": score += 30
            elif inv_level == "High": score -= 10
            
            if random_days > 30:
                score += 20
            elif random_days < 7:
                score -= 10
                
            score = max(0, min(100, score)) # clamp 0-100
            
            cursor.execute("""
                INSERT INTO retailers (id, name, lat, lng, inventoryLevel, priorityScore, lastVisited)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            """, (r_id, name, lat, lng, inv_level, score, last_visit))
            
            insert_count += 1

    conn.commit()
    conn.close()
    print(f"Successfully inserted {insert_count} retailers into {DB_PATH}.")

if __name__ == "__main__":
    main()

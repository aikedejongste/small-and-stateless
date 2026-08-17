#!/bin/bash
# Run from this directory: the Overpass queries are read as relative paths.

# Create output directory if it doesn't exist
mkdir -p output

# Get the total number of highway gas stations
echo "Fetching total gas stations data..."
total_count=$(curl -s -X POST https://overpass-api.de/api/interpreter --data-binary @q-hw-gas-total.txt -H 'Content-Type: text/plain' | jq '[.elements[] | select(.type == "node")] | length')

# Get the number of highway gas stations with fast chargers
echo "Fetching gas stations with fast chargers data..."
fc_count=$(curl -s -X POST https://overpass-api.de/api/interpreter --data-binary @q-hw-gas-with-fc.txt -H 'Content-Type: text/plain' | jq '[.elements[] | select(.type == "node")] | length')

# Calculate the percentage
percentage=$(awk "BEGIN { printf \"%.1f\", ($fc_count / $total_count) * 100 }")

# Generate the current date for the report
current_date=$(date +"%Y-%m-%d")

# Create an HTML file
cat > output/index.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fast Charger Coverage - Dutch Highway Gas Stations</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            color: #333;
            line-height: 1.6;
        }
        h1 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 30px;
        }
        .stats-container {
            display: flex;
            justify-content: space-around;
            margin: 40px 0;
            flex-wrap: wrap;
        }
        .stat-box {
            text-align: center;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin: 10px;
            flex: 1;
            min-width: 200px;
        }
        .percentage-box {
            background-color: #3498db;
            color: white;
        }
        .total-box {
            background-color: #2ecc71;
            color: white;
        }
        .fc-box {
            background-color: #e74c3c;
            color: white;
        }
        .number {
            font-size: 48px;
            font-weight: bold;
            margin: 10px 0;
        }
        .label {
            font-size: 16px;
            text-transform: uppercase;
        }
        .progress-container {
            width: 100%;
            background-color: #f1f1f1;
            border-radius: 5px;
            margin: 30px 0;
            height: 30px;
        }
        .progress-bar {
            height: 30px;
            background-color: #3498db;
            border-radius: 5px;
            width: ${percentage}%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }
        .footer {
            text-align: center;
            margin-top: 40px;
            color: #7f8c8d;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <h1>Fast Charger Coverage on Dutch Highway Gas Stations</h1>
    
    <div class="stats-container">
        <div class="stat-box percentage-box">
            <div class="label">Coverage Percentage</div>
            <div class="number">${percentage}%</div>
            <div class="label">of stations have fast chargers</div>
        </div>
    </div>
    
    <div class="progress-container">
        <div class="progress-bar">${percentage}%</div>
    </div>
    
    <div class="stats-container">
        <div class="stat-box total-box">
            <div class="label">Total Gas Stations</div>
            <div class="number">${total_count}</div>
            <div class="label">on Dutch highways</div>
        </div>
        
        <div class="stat-box fc-box">
            <div class="label">Stations with Fast Chargers</div>
            <div class="number">${fc_count}</div>
            <div class="label">electric vehicle chargers</div>
        </div>
    </div>
    
    <div class="footer">
        Data collected on ${current_date} from OpenStreetMap via Overpass API
    </div>
</body>
</html>
EOF

echo "Report generated at output/index.html"
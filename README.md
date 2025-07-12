# BigQuery Public Data Analytics with dbt

This dbt project analyzes NYC taxi data from BigQuery's public datasets.

✅ **Status: GitHub Actions configured and ready to run!**

## Project Structure

- **Models**: 
  - `nyc_taxi_summary.sql`: Aggregates taxi trip data by date
  - `taxi_zone_analysis.sql`: Analyzes pickup patterns by location zones

- **Tests**: Includes data quality tests for ensuring positive values and non-null constraints

## Setup Instructions

### 1. Google Cloud Authentication

You need to authenticate with Google Cloud to run this project. Choose one of these methods:

#### Option A: Service Account (Recommended for production)
1. Create a service account in your Google Cloud Console
2. Download the JSON key file
3. Update `profiles.yml` to use `method: service-account` and point to your key file

#### Option B: OAuth (Easier for development)
1. Install Google Cloud SDK: `brew install google-cloud-sdk`
2. Run: `gcloud auth application-default login`
3. Follow the browser authentication flow

### 2. Update Configuration

Update these values in `~/.dbt/profiles.yml`:
- `project`: Your Google Cloud project ID (currently set to: plexiform-brand-408008)
- `dataset`: Your target dataset name (currently set to: dbt_demo)

### 3. Run the Project

```bash
# Test connection
dbt debug

# Run models
dbt run

# Run tests
dbt test

# Generate documentation
dbt docs generate && dbt docs serve
```

## Models Description

### nyc_taxi_summary
- **Type**: View
- **Source**: `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2018`
- **Aggregation**: Daily summary of taxi trips for January 2018
- **Metrics**: Trip count, average distance, average fare

### taxi_zone_analysis  
- **Type**: View
- **Source**: Same as above
- **Aggregation**: Pickup analysis by location zones
- **Filter**: Single day (2018-01-01) with minimum 10 trips per zone
- **Limit**: Top 20 zones by trip volume

## Data Quality Tests

- **not_null**: Ensures critical fields are not null
- **positive_value**: Custom test ensuring numeric values are positive

## Sample Queries

After running `dbt run`, you can query the views in BigQuery:

```sql
-- View daily taxi summary
SELECT * FROM `your-project.dbt_demo.nyc_taxi_summary` 
ORDER BY pickup_date;

-- View top pickup zones
SELECT * FROM `your-project.dbt_demo.taxi_zone_analysis` 
ORDER BY daily_trips DESC;
```

## GitHub Actions CI/CD

This project includes a GitHub Actions workflow that automatically runs dbt on every push to main and pull requests.

### Required GitHub Secrets

You need to set up these secrets in your GitHub repository (Settings → Secrets and variables → Actions):

1. **`DBT_PROFILES_YML_BASE64`**: Base64 encoded profiles.yml file
   ```bash
   # Create the secret value:
   cat ~/.dbt/profiles.yml | base64
   ```

2. **`BIGQUERY_KEYFILE_JSON_BASE64`**: Base64 encoded BigQuery service account key
   ```bash
   # Create the secret value:
   cat /path/to/your/service-account-key.json | base64
   ```

### Workflow Features
- ✅ Runs `dbt debug`, `dbt clean`, `dbt deps`, `dbt seed`, `dbt run`, and `dbt test`
- ✅ Uses Python 3.11 and latest GitHub Actions
- ✅ Supports both push to main and pull requests
- ✅ Automatically sets up BigQuery credentials from secrets

## Next Steps

1. Set up proper authentication
2. Customize the project and dataset names
3. Run the models
4. Add more sophisticated transformations
5. Set up CI/CD pipeline for production deployment

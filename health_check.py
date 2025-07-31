import requests
import sys
import time

def health_check():
    """Health Check for Streamlit Platform"""
    try:
        # Check Streamlit health endpoint
        response = requests.get("http://localhost:8501/_stcore/health", timeout=5)
        
        if response.status_code == 200:
            print("✅ Health Check: OK")
            return True
        else:
            print(f"❌ Health Check Failed: Status {response.status_code}")
            return False
            
    except requests.exceptions.RequestException as e:
        print(f"❌ Health Check Error: {e}")
        return False

if __name__ == "__main__":
    max_retries = 3
    
    for attempt in range(max_retries):
        if health_check():
            sys.exit(0)  # Success
        
        if attempt < max_retries - 1:
            print(f"Retry {attempt + 1}/{max_retries} in 5 seconds...")
            time.sleep(5)
    
    sys.exit(1)  # Error
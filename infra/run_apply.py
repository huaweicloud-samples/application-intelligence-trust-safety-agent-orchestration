import subprocess
import os

os.chdir(r"C:\Users\xiang\WorkBuddy\aws-huaweisamples\huaweicloud\4批\application-intelligence-trust-safety-agent-orchestration\infra")
os.environ["TF_CLI_CONFIG_FILE"] = r"C:\Users\xiang\WorkBuddy\aws-huaweisamples\huaweicloud\4批\application-intelligence-trust-safety-agent-orchestration\infra\dev.rc"

result = subprocess.run(
    ["terraform", "apply", "-auto-approve", "-var-file=terraform.tfvars"],
    capture_output=True,
    text=True,
    encoding='utf-8'
)

print("STDOUT:")
print(result.stdout[:8000])
print("\nSTDERR:")
print(result.stderr[:2000])
print("\nReturn code:", result.returncode)

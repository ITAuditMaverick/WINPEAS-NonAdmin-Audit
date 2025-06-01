# WINPEAS-NonAdmin-Audit
PowerShell-based PEAS audit script for non-admin Windows users

# 🛡️ PEAS Audit Script for Non-Admin Users

A PowerShell-based audit tool designed to simulate privilege escalation opportunities available to a non-admin user on Windows systems. Ideal for internal auditors, blue teamers, GRC professionals, and defenders seeking attacker-simulated visibility without triggering AV/EDR alerts.

---

## 🔍 What It Does

* Enumerates Windows misconfigurations that could lead to privilege escalation
* Differentiates between **non-admin** and **admin-only** checks
* Performs safe, read-only system enumeration
* Outputs findings to both **CSV** and **HTML**
* Identifies vulnerable builds based on **known LPE CVEs**

---

## 📦 Features

* ✅ Execution context detection (admin vs non-admin)
* ✅ Token privileges & path hijack opportunities
* ✅ Credential manager exposure
* ✅ Registry autoruns (HKCU)
* ✅ Environment variables and startup folder review
* ✅ Admin-only checks (BitLocker, SeDebugPrivilege, AlwaysInstallElevated)
* ✅ CVE match for vulnerable Windows builds
* ✅ HTML and CSV reports

---

## 🚀 How to Run

```powershell
powershell -ExecutionPolicy Bypass -File .\PEAS-Enhanced-Audit.ps1
```

### Output:

* 📄 `Documents\DD_MM_YY_PEASAudit_<Hostname>_<Username>.csv`
* 🌐 `Documents\DD_MM_YY_PEASAudit_<Hostname>_<Username>.html`

> ⚠️ For full results, re-run as Administrator after initial enumeration.

---

## 📁 File Structure

```text
PEAS-NonAdmin-Audit/
├── PEAS-Enhanced-Audit.ps1      # Main script
├── README.md                    # This file
├── .gitignore                   # Recommended exclusions
├── LICENSE                      # MIT License
└── sample/
    ├── sample-output.csv
    └── sample-output.html
```

---

## 🧪 Sample Use Cases

* Internal audits for endpoint hardening
* Blue team detection engineering
* Privilege escalation simulation in lab environments
* Secure baselining of developer machines

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 🙌 Acknowledgements

Inspired by [carlospolop's PEASS-ng](https://github.com/carlospolop/PEASS-ng), this script adapts PEAS principles for a blue-team and audit-friendly context.

---

## 📬 Contributing

PRs, suggestions, and pull requests welcome. Let’s make auditing easier for defenders 💙

# GSM Network Simulator

A Bash-based GSM network simulator that validates mobile call operations by simulating essential components of a real mobile network infrastructure.

## Educational Purpose Only

**IMPORTANT:** This tool is designed strictly for educational purposes to help understand GSM network architecture, authentication mechanisms, and mobile network operations. It should NOT be used for any real-world telecommunications operations or malicious activities.

## Overview

This simulator replicates the core functionality of GSM networks by checking mobile subscriber identity, device authentication, and call authorization against local data files that simulate real network registers (VLR, EIR, HLR, AUC).

Perfect for students, researchers, and telecom enthusiasts who want to learn about mobile network architecture and understand how GSM authentication works under the hood.

## Features

- **MSISDN Validation** - Validates mobile numbers and identifies the operator (Vodafone, Etisalat, Orange)
- **IMEI Verification** - Checks device authenticity and authorization status
- **EIR Status Check** - Allows or blocks calls based on equipment identity (WHITE/BLACK/GREY listing)
- **Authentication** - Validates users against AUC (Authentication Center) keys
- **Receiver Status Monitoring** - Verifies receiver availability before call initiation
- **Color-Coded Output** - Informative, warning, and error messages for easy debugging

## Getting Started

### Prerequisites

- Bash shell environment (Linux, macOS, or WSL on Windows)
- Data files (VLR, EIR, HLR, AUC) in CSV format

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/gsm-simulator.git
cd gsm-simulator
```

2. Make the script executable:
```bash
chmod +x start_call.sh
```

3. Ensure your data files are in the same directory as the script

## Usage
```bash
./start_call.sh <caller_msisdn> <receiver_msisdn> <imei> <ki_key>
```

### Example
```bash
./start_call.sh 01011111111 01222222222 111111111111111 AB12CD34EF56AB78CD90EF12AB34CD56
```

### Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| `caller_msisdn` | Caller's mobile number | `01011111111` |
| `receiver_msisdn` | Receiver's mobile number | `01222222222` |
| `imei` | Device IMEI (15 digits) | `111111111111111` |
| `ki_key` | Authentication key (32 hex chars) | `AB12CD34EF56AB78CD90EF12AB34CD56` |

## Data Files Format

Place these CSV files in the same directory as the script:

### vlr - Visitor Location Register
Maps MSISDN to IMSI and subscriber status
```csv
msisdn,imsi,status
01011111111,602011234567890,active
01222222222,602021234567891,active
```

### eir - Equipment Identity Register
Lists IMEI statuses (WHITE, BLACK, GREY)
```csv
imei,status
111111111111111,WHITE
222222222222222,BLACK
333333333333333,GREY
```

### hlr - Home Location Register
Subscriber data and home network information
```csv
imsi,msisdn,home_network
602011234567890,01011111111,Vodafone
602021234567891,01222222222,Etisalat
```

### auc - Authentication Center
Maps IMSI to authentication keys (KI)
```csv
imsi,ki
602011234567890,AB12CD34EF56AB78CD90EF12AB34CD56
602021234567891,CD34EF56AB78CD90EF12AB34CD56AB12
```

## Call Flow Simulation

The simulator follows this authentication and authorization flow:

1. **Caller Validation** - Checks MSISDN format and identifies operator
2. **VLR Lookup** - Verifies caller is registered and has active status
3. **IMEI Check** - Validates device against EIR (Equipment Identity Register)
4. **Authentication** - Matches KI key from AUC (Authentication Center)
5. **Receiver Check** - Validates receiver registration and status
6. **Call Authorization** - Final decision to allow or deny the call

## Output Examples

Successful call:
```
[INFO] Caller 01011111111 belongs to Vodafone
[INFO] Caller found in VLR with IMSI: 602011234567890
[INFO] IMEI 111111111111111 status: WHITE - Device allowed
[SUCCESS] Authentication successful
[SUCCESS] Call allowed to 01222222222
```

Blocked call:
```
[INFO] Caller 01011111111 belongs to Vodafone
[INFO] Caller found in VLR with IMSI: 602011234567890
[ERROR] IMEI 222222222222222 status: BLACK - Device blocked
[BLOCKED] Call denied due to blacklisted device
```

## Learning Objectives

This simulator helps you understand:

- How GSM networks authenticate subscribers
- The role of different network registers (VLR, HLR, EIR, AUC)
- IMEI-based device authorization
- Mobile network security mechanisms
- Call setup and validation procedures

## Contributing

Contributions are welcome! Feel free to:

- Report bugs or issues
- Suggest new features or improvements
- Submit pull requests
- Share educational use cases

Please ensure all contributions maintain the educational focus of this project.

## License

This project is open source and available under the MIT License.

## Disclaimer

This software is provided for educational purposes only. The author is not responsible for any misuse or damage caused by this program. Users must comply with all applicable laws and regulations regarding telecommunications in their jurisdiction.

## Author

**Fouad Yasser**


## Acknowledgments

Created to help students and professionals understand GSM network architecture and authentication mechanisms through hands-on simulation.

---

If you find this educational tool useful, please consider giving it a star to help others discover it!

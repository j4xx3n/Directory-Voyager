# Directory Voyager 
  Wrapper for domain scanners to create one large list

## Kali Linux Installation Steps

Follow these steps to set up the project:

1. Clone the repository:
    ```sh
    git clone https://github.com/j4xx3n/Directory-Voyager.git
    ```

2. Navigate to the project directory:
    ```sh
    cd Directory-Voyager
    ```

3. Make the shell scripts executable:
    ```sh
    chmod u+x *.sh
    ```

4. Run the installer script:
    ```sh
    ./kali-installer.sh
    ```
## Usage
  `./DirectoryVoyager.sh [-s <domain_file>] [-p] [-a] [-f] [-c]`

Options:
  - -s <domain_file>   File containing list of target domains (required)"
  - -p                 Perform passive scans (getallurls, waybackurls, katana)"
  - -a                 Perform active scans (hakrawler, katana)"
  - -f                 Perform directory fuzzing (Currently in progress)"
  - -c                 Perform cleaning of the list"
  - -h                 Display this help message"

Example:
  `./DirectoryVoyager.sh -s example.com -p -a -f -c`
    

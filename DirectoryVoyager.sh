#!/bin/bash

# Directory Voyager
# Wrapper for domain scanners to create one large list

# ANSI color codes
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color



showHelp() {
  echo -e "${RED}Directory Voyager${NC}"
  echo -e "${BLUE}Wrapper for domain scanners to create one large list.${NC}"
  echo -e "${RED}By: J4xx3n${NC}"
  echo
  echo -e "${BLUE}Usage: ./DirectoryVoyager.sh [-s <domain_file>] [-p] [-a] [-f] [-c]${NC}"
  echo
  echo -e "${BLUE}Options:${NC}"
  echo "  -s <domain_file>   File containing list of target domains (required)"
  echo "  -p                 Perform passive scans (getallurls, waybackurls, katana)"
  echo "  -a                 Perform active scans (hakrawler, katana)"
  echo "  -f                 Perform directory fuzzing (Currently in progress)"
  echo "  -c                 Perform cleaning of the list (Filter duplicates and out of scope domains)"
  echo "  -h                 Display this help message"
  echo
  echo -e "${BLUE}Examples:${NC}"
  echo "  ./DirectoryVoyager.sh -s domains.txt -p -a"
  echo "  ./DirectoryVoyager.sh -s domains.txt -f -c 'example.com'"
}

# Create variable for target domain list
subdomains=""
passive=false
active=false
fuzz=false
clean=false

# Parse command-line options
while getopts ":s:pafch" opt; do
  case ${opt} in
    s )
      subdomains="$OPTARG"
      ;;
    p )
      passive=true
      ;;
    a )
      active=true
      ;;
    f )
      fuzz=true
      ;;
    c )
      clean=true
      ;;
    h )
      showHelp
      exit 0
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      exit 1
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))


passiveScan() {
  echo
  echo -e "${RED}Directory Voyager${NC}"
  echo -e "${BLUE}Starting passive scan....${NC}"
  
  # Run getallurls and add output to a list
  cat $subdomains | getallurls | tee -a bigCrawl

  # Run waybackurls and add output to a list
  cat $subdomains | waybackurls | tee -a bigCrawl

  # Run katana passively and add to file
  katana -list $subdomains -d 5 -ps | tee -a bigCrawl
}


activeScan() {
  echo
  echo -e "${RED}Directory Voyager${NC}"
  echo -e "${BLUE}Starting active scan....${NC}"

  # Run hakrawler and add output to a file
  cat $subdomains | hakrawler -d 5 | tee -a bigCrawl

  # Run katana actively and add to file
  katana -list $subdomains -d 5 | tee -a bigCrawl
}


fuzzScan(){
  echo
  echo -e "${RED}Directory Voyager${NC}"
  echo -e "${BLUE}Currently in progress....${NC}"


  # Fuzz subdomains list for directories
  #cp $subdomains dirFuzz
  #sed -i 's/$/\/FUZZ/' dirFuzz
  #cat dirFuzz | while read url ; do ffuf -w common.txt -u "$url" -o dirFuzz.json -s -recursion-depth 2; done
  #jq -r '.results[].url' dirFuzz.json

  # Fuzz subdomain list for paths
  #echo "Please enter domain to fuzz:"
  #read name
  # Create list for fuzzing
  #cat bigCrawl | grep = | grep ? | grep $name | uro | tee keyFuzz
  #sed -i 's/\?\([^=]*\)=/?FUZZ=/g' keyFuzz
  #sed -i 's/=\(.*\)/=readme/g' keyFuzz
  # Run ffuf against the list of domains for directories and add to a file
  #cat keyFuzz | while read url ; do ffuf -w ~/Downloads/fuzz-Bo0oM.txt -u "$url"; done
}

cleanList() {
  echo
  echo -e "${RED}Directory Voyager${NC}"
  echo -e "${BLUE}Cleaning list....${NC}"

  # Create a variable for in-scope domains
  baseDomains=$(awk -F'.' '{print $(NF-1)"."$NF}' $subdomains  | sort | uniq)

  # Sort out duplicates and urls not in scope
  cat bigCrawl | grep -f $baseDomains | sort -u | tee bigCrawl

  echo
  echo -e "${BLUE}List cleaned${NC}"
}

# Main function to call other functions
main() {
  if [ "$passive" = true ]; then
    passiveScan
  fi

  if [ "$active" = true ]; then
    activeScan
  fi

  if [ "$fuzz" = true ]; then
    fuzzScan
  fi

  if [ "$clean" = true ]; then
    cleanList
  fi
}

main

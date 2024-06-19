#!/bin/bash

# Wrapper for the most reputable domain scanners to create one large list
# Crawlers to use: hakrawler, getallurls, waybackurls


# ANSI color codes
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color



showHelp() {
  echo -e "${RED}Directory Voyager${NC}"
  echo -e "${BLUE}Wrapper for domain scanners to create one large list.${NC}"
  echo -e "${RED}By: J4xx3n${NC}"
  echo
  echo -e "${BLUE}Usage: domain_crawler.sh [-s <domain_file>] [-p] [-a] [-f] [-c]${NC}"
  echo
  echo -e "${BLUE}Options:${NC}"
  echo "  -s <domain_file>   File containing list of target domains (required)"
  echo "  -p                 Perform passive scans (getallurls, waybackurls, katana)"
  echo "  -a                 Perform active scans (hakrawler, katana)"
  echo "  -f                 Perform directory fuzzing (currently in production)"
  echo "  -c                 Perform cleaning of the list with specific criteria (currently disabled)"
  echo "  -h                 Display this help message"
  echo
  echo -e "${BLUE}Examples:${NC}"
  echo "  ./domain_crawler.sh -s domains.txt -p -a"
  echo "  ./domain_crawler.sh -s domains.txt -f -c 'example.com'"
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
  echo -e "${RED}Directory Voyager${NC}"
  echo -e "${BLUE}Starting active scan....${NC}"

  # Run hakrawler and add output to a file
  cat $subdomains | hakrawler -d 5 | tee -a bigCrawl

  # Run katana actively and add to file
  katana -list $subdomains -d 5 | tee -a bigCrawl
}


fuzzScan(){
  echo -e "${RED}Directory Voyager${NC}"
  echo -e "${BLUE}Starting passive scan....${NC}"

  # Fuzz domain list for paths
  #echo "Please enter domain to fuzz:"
  echo "Fuzz function out of commition."
  #read name
  # Create list for fuzzing
  #cat bigCrawl | grep = | grep ? | grep $name | uro | tee keyFuzz
  #sed -i 's/\?\([^=]*\)=/?FUZZ=/g' keyFuzz
  #sed -i 's/=\(.*\)/=readme/g' keyFuzz
  # Run ffuf against the list of domains for directories and add to a file
  #cat keyFuzz | while read url ; do ffuf -w ~/Downloads/fuzz-Bo0oM.txt -u "$url"; done
}

cleanList() {
  echo -e "${RED}Directory Voyager${NC}"
  echo -e "${BLUE}Cleaning list....${NC}"
  # Sort out duplicates and urls not in scope
  cat bigCrawl | sort -u | tee bigCrawl
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

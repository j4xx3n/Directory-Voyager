#!/bin/bash

# Wrapper for the most reputable domain scanners to create one large list
# Crawlers to use: hakrawler, getallurls, waybackurls


echo "Domain crawler wrapper"
echo "By: J4xx3n"

# Create variable for target domain list
subdomains=""
passive=false
active=false

# Parse command-line options
while getopts ":s:pa" opt; do
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



# Use all tools to crawl domain and add to a file
passiveScan() {
  # Run
  hakrawler and add output to a file
  cat subdomains | hakrawler -i -d 5 | tee -a bigCrawl &

  # Run getallurls and add output to a list
  cat subdomains | gau | tee -a bigCrawl &

  # Run waybackurls and add output to a list
  #waybackList=$(waybackurls $domain)
  cat subdomains | waybackurls | tee -a bigCrawl &

  # Run katana and add to file
  #katana -list subdomains | tee -a bigCrawl &

  # Wait for all processes to finish
  wait
}


# Fuzz domain list for paths
activeScan() {

  # Fuzz domain list for paths
  echo "Please enter domain to fuzz:"
  read name
  # Create list for fuzzing
  cat bigCrawl | grep = | grep ? | grep $name | uro | tee keyFuzz
  sed -i 's/\?\([^=]*\)=/?FUZZ=/g' keyFuzz
  sed -i 's/=\(.*\)/=readme/g' keyFuzz
  # Run ffuf against the list of domains for directories and add to a file
  cat keyFuzz | while read url ; do ffuf -w ~/Downloads/fuzz-Bo0oM.txt -u "$url"; done

}


# Main function to call other functions
main() {
  if [ "$passive" = true ]; then
    passiveScan
  fi

  if [ "$active" = true ]; then
    activeScan
  fi
}

main

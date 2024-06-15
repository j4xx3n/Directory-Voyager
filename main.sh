#!/bin/bash

# Wrapper for the most reputable domain scanners to create one large list
# Crawlers to use: hakrawler, getallurls, waybackurls

# ASCII title
echo "
                              
@@@  @@@  @@@  @@@  @@@@@@@@  
@@@  @@@  @@@@ @@@  @@@@@@@@  
@@!  !@@  @@!@!@@@       @@!  
!@!  @!!  !@!!@!@!      !@!   
@!@@!@!   @!@ !!@!     @!!    
!!@!!!    !@!  !!!    !!!     
!!: :!!   !!:  !!!   !!:      
:!:  !:!  :!:  !:!  :!:       
 ::  :::   ::   ::   ::       
 :   :::  ::    :   : :
"
echo "Domain crawler wrapper"
echo "By: J4xx3n"

# Create variable for target domain list
domain=""
fuzzOption=false

# Parse command-line options
while getopts ":d:f" opt; do
  case ${opt} in
    d )
      domain="$OPTARG"
      ;;
    f )
      fuzzOption=true
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
crawler() {
  # Run hakrawler and add output to a file
  cat domain | hakrawler | tee -a bigCrawl &

  # Run getallurls and add output to a list
  cat domain | getallurls -threads 8 | tee -a bigCrawl &

  # Run waybackurls and add output to a list   
  #waybackList=$(waybackurls $domain)
  cat domain | waybackurls | tee -a bigCrawl &

  # Run katana and add to file
  katana -list subdomains | tee -a bigCrawl &

  # Wait for all processes to finish
  wait
}


# Fuzz domain list for paths
fuzzer() {
  # Check if -f option is provided
  if [ "$fuzzOption" = true ]; then
    # Run ffuf against the list of domains for directories and add to a file
    ffuf -c -w "/path/to/wordlist.txt" -maxtime-job 60 -recursion -recursion-depth 5 -u $domain/FUZZ | tee -a bigCrawl
  else
    echo "Skipping fuzzing"
  fi
}

# Clean up directory list
cleaner() {
  

}

# Main function to call other functions
main() {
  crawler
  fuzzer
}

main

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


# Create variable for target domain
domain=""

# Parse command-line options
while getopts ":d:" opt; do
  case ${opt} in
    d )
      domain="$OPTARG"
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


crawl() {
    # Use all tools to crawl domain and add to variables

    # Run hakrawler and add output to a variable
    hakrawlerList=$(hakrawler -d $domain)

    # Run getallurls and add output to a variable
    gauList=$(getallurls $domain)

    # Run waybackurls and add output to a variable   
    waybackList=$(waybackurls $domain)
}

combine() {
    # Add all the subdomain list variables together and remove the duplicates
    unfilteredCombo="${hakrawlerList} + ${gauList} + ${waybackList}"
    echo $unfilteredCombo | sort -u | tee comboList.txt
}


main() {
    # Main function to call other functions
    crawl
    combine
}
#!/bin/bash
 
sudo apt update
sudo apt install golang-go -y
sudo apt install getallurls  
go install github.com/tomnomnom/waybackurls@latest
go install github.com/hakluke/hakrawler@latest
#go install github.com/projectdiscovery/katana/cmd/katana@latest
sudo mv ~/go/bin/* /usr/bin/

#!/bin/bash


  
USER=$(logname)  
HOME="/home/${USER}/"

#
# echo "Deleting all personal files (for public computers)"
#


rm -r $HOME/Downloads/*
rm $HOME/*
rm $HOME/.local/share/RecentDocuments/*
rm $HOME/.kde/share/apps/RecentDocuments/*

    	


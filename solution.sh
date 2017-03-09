#Important Note: Run the solution.sh file in the same Directory in which the products.txt and listings .txt file is residing


echo ' ' > results.txt #making output file ready to append results json objects.

while read p; do  #Extracting the line by line input from the file products.txt
	prodname1=$(echo $p | grep -Po '"product_name":.*?[^\\]"' | grep -Po '[:].*' | cut -d ':' -f2 | cut -d '"' -f2); # From the line, it will fetch the product_name in JSON into the variable prod_name
	
	prodname=$(echo $prodname1 | sed -r 's/[-_]/ /g'); #it will replace all occurence of special characters like Hyphen(-) and Underscore(_) with whitespace( )
	#echo 'Prodname Seprated is ->'$prodname    #for debuging purpose
	for word in $prodname   # It willl seprate each word from product_name fetched whch is without underscore and hyphen.
	do
		#echo 'Word is -> '$word;
		vari=$(grep $word listings.txt); #it will find each word in file listing.txt and incrementally assign the values to the variable $vari
		lines=$(grep $word listings.txt | wc -l);  #it counts the number of lines having all words in variable $prod_name, if it has ZERO (0) records then it will print cut command help on the command line.
	done

	lines=$(($lines-1));
	#echo 'Number of lines is ->'$lines;

		varx='{"product_name":"'$prodname1'","listings":["';  #initialize json object and content of array will be appended to this variable.
	for i in `seq 1 $lines`     #For each lines having the words in listing.txt we will separate the objects and extract the content of titles present in the Object.
	do
		var1=$(echo $vari | cut -d '}' -f$i);
		var1=$(echo $var1 | grep -Po '"title":.*?[^\\]"' | grep -Po '[:].*' | cut -d ':' -f2 | cut -d '"' -f2);
		varx=$varx$var1'","';    #Append the title Array to the Object upto second last element.
	done

	lines=$(($lines+1));
		varne=$(echo $vari | cut -d '}' -f$lines);
		varne=$(echo $varne | grep -Po '"title":.*?[^\\]"' | grep -Po '[:].*' | cut -d ':' -f2 | cut -d '"' -f2);
	varx=$varx$varne'"]}';     #This statement will add the last element of array in object and close the object and written to the results.txt
	varx=$varx;
	echo -e $varx >> results.txt;

done <products.txt



#The Operational Time complexity of the code is O(n^2).

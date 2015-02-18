#!/usr/bin/perl -w

$another = 'y';

while ($another eq 'y'){

my $result = "/etc/bacula/backups.txt";
my $outputFile=">$result";

open (OUTFILE,$outputFile) || die $!; #name of results file

print "\tWhat is the server name? ";
chomp ($servername=<STDIN>);

#print "\tWhat is the name of the fileset?\n";
#chomp ($filesetname=<STDIN>);

print OUTFILE "JobDefs {\n";
print OUTFILE "  Name = \"$servername\"\n";
print OUTFILE "  Type = Backup\n";
print OUTFILE "  Level = Incremental\n";
print OUTFILE "  Client = $servername-fd\n";
print OUTFILE "  FileSet = \"\u$servername Set\"\n";
print OUTFILE "  Schedule = \"WeeklyCycle\"\n";
print OUTFILE "  Storage = File\n";
print OUTFILE "  Messages = Standard\n";
print OUTFILE "  Pool = ${servername}-pool\n";
print OUTFILE "  Priority = 10\n";
print OUTFILE "\}\n\n";

print OUTFILE "Job {\n";
print OUTFILE "  Name = \"${servername}client\"\n";
print OUTFILE "  JobDefs = \"$servername\"\n";
print OUTFILE "  Write Bootstrap = \"/var\/lib\/bacula\/${servername}\.bsr\"\n";
print OUTFILE "\}\n\n";

print OUTFILE "FileSet \{\n";
print OUTFILE "  Name = \"\u$servername Set\"\n";

print "\tIs this located on a Windows OS? ";
chomp ($os=<STDIN>);
	if ($os eq 'y'){
		print OUTFILE "  Enable VSS = yes\n";
		print "\tUse a forward slash in your next answer (e.g. c:/path or d:/path)\n";
		}

print OUTFILE "  Include \{\n";
print OUTFILE "    Options \{\n";
print OUTFILE "      signature \= MD5\n";
print OUTFILE "    }\n";

$enterlocation = 'y';

	while ($enterlocation eq 'y'){
		print "\tEnter file or directory to backup: ";
		chomp ($location=<STDIN>);
		print OUTFILE "    File = \"$location\"\n";
		print "\tWant to enter another file or directory? ";
		chomp ($enterlocation=<STDIN>);
	}

	print OUTFILE "   }\n";

	print OUTFILE " Exclude {\n";
	print "\tAre there any files or directories to exclude? ";
	chomp ($excludes=<STDIN>);
	while ($excludes eq 'y'){
		print "\tEnter location to exclude: ";
		chomp ($nobackup=<STDIN>);
		print OUTFILE "     File = $nobackup\n";
		print "\tAnother exclude? ";
		chomp ($excludes=<STDIN>);
		}
	print OUTFILE "  }\n";
	print OUTFILE "}\n";
print OUTFILE "\nClient {\n";
print OUTFILE "  Name = ${servername}-fd\n";
print OUTFILE "  Address = $servername\n";
print OUTFILE "  FDPort = 9102\n";
print OUTFILE "  Catalog = MyCatalog\n";
print OUTFILE "  Password = \"somepassword\"          \# password for FileDaemon\n";

print "\tHow long will the files be saved? ";
        chomp ($fileretention=<STDIN>);
	print OUTFILE "  File Retention = $fileretention\n";


print "\tHow long will the job be saved? ";
        chomp ($jobretention=<STDIN>);
	print OUTFILE "  Job Retention = $jobretention\n";
print OUTFILE "  AutoPrune = yes                     \# Prune expired Jobs\/Files\n";
print OUTFILE "\}\n\n";

print OUTFILE "Pool {\n";
print OUTFILE "  Name = ${servername}-pool\n";
print OUTFILE "  Pool Type = Backup\n";
print OUTFILE "  Recycle = Yes\n";
print "\tHow long will the volume be saved? ";
	chomp ($volretention=<STDIN>);
print OUTFILE "  Volume Retention = $volretention\n";
print "\tEnter the maximum volume bytes \(e.g. 100000000000\=100gb\) ";
	chomp ($maxbytes=<STDIN>);
print OUTFILE "  Maximum Volume Bytes = $maxbytes\n";
print OUTFILE "  Label Format = $servername-\n";
print OUTFILE "  Maximum Volumes = 2\n";
print OUTFILE "}\n";

print "\tConfigure another backup? ";
chomp ($another=<STDIN>);
	if($another eq 'n'){
	print "\n\tbackups.txt has been written to /etc/bacula/backups.txt\n\n";
	}
}

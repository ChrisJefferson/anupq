#############################################################################
####
##
#W  anupqhead.g             ANUPQ Share Package                 Werner Nickel
#W                                                                Greg Gamble
##
##  `Head' file for the GAP interface to the ANU pq binary by Eamonn O'Brien.
##    
#H  @(#)$Id$
##
#Y  Copyright (C) 2001  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
Revision.anupqhead_g :=
    "@(#)$Id$";


#############################################################################
##
#V  ANUPQData . . record used by various functions of the ANUPQ share package
##
##  The fields of ANUPQData are:
##
##    "binary"  . . the path of the pq binary
##    "tmpdir"  . . the path of the temporary directory for pq i/o files
##    "io"  . . . . list of data records for PqStart IO Streams
##    "outfile" . . the path of the pq output file
##    "SPimages"  . the path of the pq GAP_library file
##    "version" . . the version of the current pq binary
##
ANUPQData := rec( binary := Filename( DirectoriesPackagePrograms( "anupq" ),
                                      "pq"),
                  tmpdir := DirectoryTemporary(),
                  ni := rec(), # record for non-interactive functions
                  io := []     # list of records for PqStart IO Streams,
                               #  of which, there are initially none
                  );
ANUPQData.outfile := Filename( ANUPQData.tmpdir, "PQ_OUTPUT" );
ANUPQData.SPimages := Filename( ANUPQData.tmpdir, "GAP_library" );

# Fire up ANUPQ with the code for exit 
# ... to generate a banner (which has ANUPQ's current version)
Exec( Concatenation( ANUPQData.binary, " -v >", ANUPQData.outfile ) );
# For now use ANUPQData.scratch for an input stream
ANUPQData.scratch := InputTextFile( ANUPQData.outfile );
# Grab the first line of outfile, which has the version number of the binary
ANUPQData.version := ReadLine( ANUPQData.scratch );
CloseStream( ANUPQData.scratch );
# We just want the N.n part of the first line of outfile
# ... ANUPQData.scratch now records where N.n starts
ANUPQData.scratch := PositionSublist( ANUPQData.version, "Version" ) + 8;
ANUPQData.version := ANUPQData.version{ [ANUPQData.scratch ..
                                         Length(ANUPQData.version) - 1] };
Unbind( ANUPQData.scratch ); # We don't need ANUPQData.scratch, anymore.

#############################################################################
##  
#I  InfoClass
##
DeclareInfoClass( "InfoANUPQ" );

# Set the default level of InfoANUPQ
SetInfoLevel( InfoANUPQ, 1 );

#############################################################################
##
##  Print a banner . . . . . .  using InfoWarning (so a user can turn it off)
##
Info(InfoWarning,1,"  Loading the ANUPQ (ANU p-Quotient) share package");
Info(InfoWarning,1,"  C code by  Eamonn O'Brien <obrien@math.auckland.ac.nz>");
Info(InfoWarning,1,"              ANU pq binary version: ", ANUPQData.version);
Info(InfoWarning,1,"  GAP code by Werner Nickel <nickel@mathematik.tu-darmstadt.de>");
Info(InfoWarning,1,"          and   Greg Gamble  <gregg@math.rwth-aachen.de>");
Info(InfoWarning,1,"              ANUPQ package version: ",
                                    PACKAGES_VERSIONS.anupq);
Info(InfoWarning,1,"");
Info(InfoWarning,1,"              For help, type: ?ANUPQ");

#############################################################################
##
##  Ensure no zombie `pq' processes from interactive (`PqStart') sessions are 
##  left lying around when user quits GAP.
##
InstallAtExit( PqQuitAll );

#E  anupqhead.g . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 

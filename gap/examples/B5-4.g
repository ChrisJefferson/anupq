###########################################################################
##
#W  B5-4.g                    ANUPQ Example                   Werner Nickel
##          
#H  $Id$
##
##  This file contains code to rebuild the Burnside group B(5,4).  This is 
##  the largest group of exponent 4 generated by 5 elements.  It has order
##  2^2728 and p-central class 13.  The code is based on an input file
##  by M.F.Newman for the ANUPQ standalone to construct B(5,4).
##
##  The construction here uses the knowledge gained by Newman & O'Brien in
##  their initial construction of B(5,4), in particular insight into the
##  commutator structure of the group and the knowledge of the p-central
##  class and the order of B(5,4).  Therefore, the construction here cannot
##  be used to prove that B(5,4) has the order and class mentioned above.  It
##  is merely a reconstruction of the group.
##
##  Detailed information can be obtained from the references given in the
##  following excerpt from Math Reviews.  In particular, for the use of the
##  left-normed commutators in the construction the monograph by Vaughan-Lee
##  cited below should be consulted.
##
##      97k:20002 20-04 (20D15 20F05) 
##      Newman, M. F.; O'Brien, E. A.
##      Application of computers to questions like those of Burnside II
##      Internat. J. Algebra Comput. 6 (1996), no. 5, 593--605. 
##      
##      The paper describes improvements to the ANU $p$-quotient algorithm
##      made since the time of the earlier survey on the program (the
##      Canberra nilpotent quotient program) (see Part I [G. Havas and
##      M. F. Newman, in Burnside groups (Proc. Workshop, Univ. Bielefeld,
##      Bielefeld, 1977), 211--230, Lecture Notes in Math., 806, Springer,
##      Berlin, 1980; MR 82d:20002], and also the two monographs by
##      M. Vaughan-Lee [The restricted Burnside problem, Second edition,
##      Oxford Univ. Press, New York, 1993; MR 98b:20047], and C. C. Sims
##      [Computation with finitely presented groups, Cambridge Univ. Press,
##      Cambridge, 1994; MR 95f:20053]). One main area of change since the 
##      earlier survey is the use of the collection from the left [see, for
##      example, C. R. Leedham-Green and L. H. Soicher, J. Symbolic Comput. 9
##      (1990), no. 5-6, 665--675; MR 92b:20021; M. Vaughan-Lee, J. Symbolic
##      Comput. 9 (1990), no. 5-6, 725--733; MR 92c:20065].  
##      
##      From the solution to the restricted Burnside problem by
##      E. I. Zelmanov [Mat. Sb. 182 (1991), no. 4, 568--592; MR 93a:20063],
##      the basic Burnside question is that of determining the order of
##      $R(d,e)$, the largest finite $d$-generator group of exponent $e$. New
##      advances in the algorithm (in particular the use of some of the
##      automorphisms of the Burnside groups) are described and the
##      restricted Burnside groups $R(5,4)$ and $R(3,5)$ are shown to have
##      orders $2\sp {2728}$ and $5\sp {2882}$, respectively.
##      
##                                     Reviewed by Colin M. Campbell 
##
#Example: "B5-4.g" . . . by Werner Nickel
#. . . . . . . . . . . . and based on a pq input file by M.F.Newman
#(constructs the Burnside group B(5,4), which is the largest group of 
# exponent 4 generated by 5 elements; it has order 2^2728 and p-central
# class 13)
#Note: It is a construction only and makes use of specialised knowledge
#gained by Newman & O'Brien in their investigations of B(5,4).
#vars: procId, Relations, class, w, smallclass;
#options: OutputFile
RequirePackage( "anupq" );
##You might like to try setting: `SetInfoLevel( InfoANUPQ, 3 );'

procId := PqStart( FreeGroup(5) : Exponent := 4, Prime := 2 );
Pq( procId : ClassBound := 2 );
PqSupplyAutomorphisms( procId,
      [
        [ [ 1, 1, 0, 0, 0],      #1st automorphism
          [ 0, 1, 0, 0, 0],
          [ 0, 0, 1, 0, 0],
          [ 0, 0, 0, 1, 0],
          [ 0, 0, 0, 0, 1] ],

        [ [ 0, 0, 0, 0, 1],      #2nd automorphism
          [ 1, 0, 0, 0, 0],
          [ 0, 1, 0, 0, 0],
          [ 0, 0, 1, 0, 0],
          [ 0, 0, 0, 1, 0] ]
                             ] );;

Relations :=
  [ [],          ## class 1
    [],          ## class 2
    [],          ## class 3
    [],          ## class 4
    [],          ## class 5
    [],          ## class 6
    ## class 7     
    [ [ "x2","x1","x1","x3","x4","x4","x4" ] ],
    ## class 8
    [ [ "x2","x1","x1","x3","x4","x5","x5","x5" ] ],
    ## class 9
    [ [ "x2","x1","x1","x3","x4","x4","x5","x5","x5" ],
      [ "x2","x1","x1","x2","x3","x4","x5","x5","x5" ],
      [ "x2","x1","x1","x3","x3","x4","x5","x5","x5" ] ],
    ## class 10
    [ [ "x2","x1","x1","x2","x3","x3","x4","x5","x5","x5" ],
      [ "x2","x1","x1","x3","x3","x4","x4","x5","x5","x5" ] ],
    ## class 11
    [ [ "x2","x1","x1","x2","x3","x3","x4","x4","x5","x5","x5" ],
      [ "x2","x1","x1","x2","x3","x1","x3","x4","x2","x4","x3" ] ],
    ## class 12
    [ [ "x2","x1","x1","x2","x3","x1","x3","x4","x2","x5","x5","x5" ],
      [ "x2","x1","x1","x3","x2","x4","x3","x5","x4","x5","x5","x5" ] ],
    ## class 13
    [ [ "x2","x1","x1","x2","x3","x1","x3","x4","x2","x4","x5","x5","x5" 
        ] ]
];

for class in [ 3 .. 13 ] do
    Print( "Computing class ", class, "\n" );
    PqSetupTablesForNextClass( procId );

    for w in [ class, class-1 .. 7 ] do

        PqAddTails( w );   
        PqAPQDisplayPresentation( procId );

        if Relations[ w ] <> [] then
            # recalculate automorphisms
            PqExtendAutomorphisms( procId );

            for r in Relations[ w ] do
                Print( "Collecting ", r, "\n" );
                PqCommutator( procId, r, 1 );
                PqEchelonise( procId );
                PqApplyAutomorphisms( procId, 15 ); #queue factor = 15
            od;

            PqEliminateRedundantGenerators( procId );
        fi;   
        PqComputeTails( procId, w );
    od;
    PqAPQDisplayPresentation( procId );

    smallclass := Minimum( class, 6 );
    for w in [ smallclass, smallclass-1 .. 2 ] do
        PqTails( w );
    od;
    # recalculate automorphisms
    PqExtendAutomorphisms( procId );
    PqCollect( procId, "x5^4" );
    PqEchelonise( procId );
    PqApplyAutomorphisms( 15 ); #queue factor = 15
    PqEliminateRedundantGenerators( procId );
    PqAPQDisplayPresentation( procId );
od;

#comment: save the presentation to a different file by supplying <OutputFile>
#sub <OutputFile> for </tmp/B54> if set and ok
PqWritePcPresentation( procId, "/tmp/B54" );;
PqQuit( procId );;

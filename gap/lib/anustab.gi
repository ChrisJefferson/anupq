#############################################################################
####
##
#A  anustab.gi               ANUPQ share package               Eamonn O'Brien
#A                                                              Werner Nickel
##
#A  @(#)$Id$
##
#Y  Copyright 1993-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
#Y  Copyright 1993-2001,  School of Mathematical Sciences, ANU,     Australia
##
#W  Greg Gamble reformulated the original code as a function and  then  split
#W  the original `anustab.g' into the declare/install files anustab.g[di].
##
##  Install file for function to  compute  the  stabiliser  of  an  allowable
##  subgroup; description is written to file LINK_output.
##
Revision.anustab_gi :=
    "@(#)$Id$";

#############################################################################
##
#F  PqStabiliserOfAllowableSubgroup( <ANUPQglb>, <F>, <gens>, <relativeOrders>,
##  <ANUPQsize>, <ANUPQagsize>) . .  compute stabiliser of allowable subgroup
##
##  computes stabiliser and writes `LINK_output' output  file  for  the  `pq'
##  binary. The `LINK_output' file is written to `ANUPQData.tmpdir', but when
##  the `pq' binary was started up directly by the user that directory is set
##  to    the    current    directory.    The    argument    variables     of
##  `PqStabiliserOfAllowableSubgroup' are essentially the variables  assigned
##  to by `GAP_link_via_file.c' in the `pq' source code.
##
if IsBound( LOADED_PACKAGES.autpgrp ) then

  InstallGlobalFunction( PqStabiliserOfAllowableSubgroup, 
  function( ANUPQglb, F, gens, relativeOrders, ANUPQsize, ANUPQagsize )
  local m, n, H, pcgs, aut, NumberAgAutos, i, imgs, NumberGlAutos, p, d,
        ANUPQMaxDegree, V, elm, baseU, id, baseN, infoLevelAutGrp, LINK_output,
        soluble, a, mat;
  
    # get the p-group
    m := Length (ANUPQglb.glAutos[1]);   
    n := Length (Pcgs(F));
    H := F / Subgroup (F, Pcgs(F){[m+1 .. n]}); IsPGroup(H);
    pcgs := Pcgs(H);
  
    # set up automorphism rec
    aut := rec();
  
    NumberAgAutos := Length (ANUPQglb.agAutos); 
    aut.agAutos := [1..NumberAgAutos];
    for i in [1..Length (ANUPQglb.agAutos)] do 
      Immutable( ANUPQglb.genQ[i] );
      ConvertToMatrixRep( ANUPQglb.genQ[i], ANUPQglb.F );
      imgs := List( ANUPQglb.agAutos[i], x -> PcElementByExponents( pcgs, x ) );
      aut.agAutos[i] := PGAutomorphism( H, pcgs, imgs);
      aut.agAutos[i]!.mat := ANUPQglb.genQ[i];
    od;
    aut.agAutos := Reversed( aut.agAutos );
    aut.agOrder := Reversed (relativeOrders);
  
    NumberGlAutos := Length( ANUPQglb.glAutos );
    aut.glAutos := [1..NumberGlAutos];
    for i in [1..NumberGlAutos] do 
      Immutable( ANUPQglb.genQ[i] );
      ConvertToMatrixRep( ANUPQglb.genQ[NumberAgAutos + i], ANUPQglb.F );
      imgs := List( ANUPQglb.glAutos[i], x -> PcElementByExponents( pcgs, x ) );
      aut.glAutos[i] := PGAutomorphism( H, pcgs, imgs);
      aut.glAutos[i]!.mat := ANUPQglb.genQ[NumberAgAutos+ i];
    od;
  
    aut.field    := ANUPQglb.F;
    aut.group    := H;
    if IsBound( ANUPQsize ) then
      aut.size     := ANUPQsize;
    fi;
    aut.one      := IdentityPGAutomorphism( H );
    aut.one!.mat := IdentityMat( ANUPQglb.q, aut.field );
  
    # add perm oper
    p := Size( aut.field );
    d := RankPGroup( aut.group );
    #compute perm rep having at most this degree
    ANUPQMaxDegree := 10000;
    if p^d <= ANUPQMaxDegree then
      V := aut.field^d;
      elm := Elements( V );
      aut.glOper := [];
      for i in [1..NumberGlAutos] do
          a := aut.glAutos[i]; 
          mat := List(a!.baseimgs, x -> ExponentsOfPcElement( pcgs, x ){[1..d]});
          mat := mat * One( aut.field );
          Immutable( mat );
          ConvertToMatrixRep( mat, aut.field );
          aut.glOper[i] := Permutation( mat, elm, OnRight );
      od;
      #PrintTo("perms", "aut.glOper := ", aut.glOper,"; \n" );
      aut.glOrder := Size( Group( aut.glOper, () ) );
    else
      aut.glOrder := ANUPQsize / Size(ANUPQglb.F)^(ANUPQagsize);
    fi;
  
    Info(InfoANUPQ, 2, "Order of GL subgroup is ", aut.glOrder);
    Info(InfoANUPQ, 2, "No. of soluble autos is ", Length (aut.agAutos));
  
    # get allowable subgroup and nucleus
    baseU := gens * One (aut.field);
    id := IdentityMat( ANUPQglb.q, aut.field);
    baseN := id{[1..ANUPQglb.r]};
  
    # call stabilizer
    infoLevelAutGrp := InfoLevel( InfoAutGrp );
    if InfoLevel( InfoANUPQ ) >= 2 then
      SetInfoLevel( InfoAutGrp, 3 );
    fi;
    PGOrbitStabilizer( aut, baseU, baseN, false );    
  
    if (Length (aut.glAutos) = 0) then 
      soluble := -1;
    else 
      soluble := 0;
    fi;
  
    aut.agAutos := Reversed (aut.agAutos);
    aut.agOrder := Reversed (aut.agOrder);
  
    LINK_output := Filename( ANUPQData.tmpdir, "LINK_output" );
    PrintTo (LINK_output, soluble);
    AppendTo (LINK_output, "\n");
    AppendTo (LINK_output, Length (aut.agAutos));
    AppendTo (LINK_output, "\n");
    for i in [1..Length (aut.agOrder)] do 
      AppendTo (LINK_output, aut.agOrder[i]);
      AppendTo (LINK_output, "\n");
    od;
    AppendTo (LINK_output, Length (aut.agAutos) + Length (aut.glAutos) );
    AppendTo (LINK_output, "\n");
    for a in aut.agAutos do
      mat := List( a!.baseimgs, x -> ExponentsOfPcElement( pcgs, x ) );
      mat := Flat( mat );
      for m in mat do
          AppendTo (LINK_output, m, " " );
      od;
      AppendTo (LINK_output, "\n");
    od;
    for a in aut.glAutos do
      mat := List( a!.baseimgs, x -> ExponentsOfPcElement( pcgs, x ) );
      mat := Flat( mat );
      for m in mat do
          AppendTo (LINK_output, m, " " );
      od;
      AppendTo (LINK_output, "\n");
    od;
    SetInfoLevel( InfoAutGrp, infoLevelAutGrp );
  end );
  
else

  InstallGlobalFunction( PqStabiliserOfAllowableSubgroup, function(arg)
    Error( "share package ``AutPGrp'' is not available.\n",
           "Please install the package so that GAP can compute\n",
           "the stabilisers needed by the pq binary.\n",
           "See the installation instructions for the ",
           "``ANUPQ'' share package.\n" );
  end );

fi;

#E  anustab.gi  . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 

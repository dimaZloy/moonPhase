
# DL
# rev 12-Feb-2020
# simple program to detect and display the phase of the moon using Julia 1.3.1
# using PackageCompiler
# build_executable("moonphasetest.jl")

using AstroLib;
using Dates; 
using PyPlot;


Base.@ccallable function julia_main(ARGS::Vector{String})::Cint

    try
	
	real_main();
	##wait_for_key();

    catch
        Base.invokelatest(Base.display_error, Base.catch_stack())
        return 1
    end

    return 0  
end


function real_main()

jdm1 = jdcnv( Dates.now()-Dates.Day(1) );
jd =   jdcnv( Dates.now() ); # returns the number of Julian days for current time
jdp1 = jdcnv( Dates.now()+Dates.Day(1) );

## The illuminated fraction k of Moon's disk, with 0 <= k <= 1. 
## k = 0 indicates a new moon, while k = 1 stands for a full moon.

km1 = mphase(jdm1);   ## yesterday
kn  = mphase(jd);     ## today
kp1 = mphase(jdp1);   ## tomorrow

moonMotion="";

if (kp1-kn > 0) 
   moonMotion = "Moon Phase increasing";
else
   moonMotion = "Moon Phase decreasing";
end


println(Dates.now());
println(moonMotion);
println("Moon phase[%]: ", kn);


##  plot motion of the moon in the range +/- 15 days from now()

dhl1 =  Dates.now() - Dates.Day(15) ; 
dhl2 =  Dates.now() + Dates.Day(15) ;

points = dhl1:Dates.Hour(1):dhl2;
figure(1)
clf();
plot(points, mphase.(jdcnv.(points)))
plot(Dates.now(),kn,"or",Markersize = 6);
xlabel("Time");
ylabel("Moon Phase");
title(moonMotion);
grid();

show(); ## call GUI explicitly in non-interactive mode!

end


function wait_for_key(; prompt = "press any key", io = stdin)
    setraw!(raw) = ccall(:jl_tty_set_mode, Int32, (Ptr{Cvoid},Int32), io.handle, raw)
    print(io, prompt)
    setraw!(true)
    read(io, 1)
    setraw!(false)
    nothing
end


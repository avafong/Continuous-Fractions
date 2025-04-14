use context shared-gdrive("contfracs-context.arr", "1mr5nHB7DDdOffE_hiovBiEuuBsl_59Gh")
include shared-gdrive("contfracs-definitions.arr", "1fFz3TaWdZgIfNxSGVYx0UQz_GXOBIVsc")

provide: *, type * end
# END HEADER
# DO NOT CHANGE ANYTHING ABOVE THIS LINE
#
# Write data bindings here that you'll need for tests in both contfracs-code.arr and contfracs-tests.arr


#------------------------------------------------------------------------------------------
# Defining some streams:

rec ones = lz-link(1, {(): ones})
rec ones-opt = lz-link(some(1), {(): ones-opt})
rec r123 = lz-link(1, {(): lz-link(2, {(): lz-link(3, {(): r123})})})
rec r123-neg = lz-link(-1, {(): lz-link(-2, {(): lz-link(-3, {(): r123-neg})})})
rec twos = lz-link(2, {(): twos})
rec twos-opt = lz-link(some(2), {(): twos-opt})
rec r123-opt = lz-link(some(1), {(): lz-link(some(2), {(): lz-link(some(3), {(): r123-opt})})})
rec r234 = lz-link(2, {(): lz-link(3, {(): lz-link(4, {(): r234})})})
rec nones = lz-link(none, {(): nones})
r123-nones = lz-link(some(1), {(): lz-link(some(2), {(): lz-link(some(3), {(): nones})})})

cf-pi-opt-7 :: Stream<Option<Number>> = 
  lz-link(some(3), 
    {(): lz-link(some(7), 
        {(): lz-link(some(15), 
            {(): lz-link(some(1), 
                {(): lz-link(some(292), 
                    {(): lz-link(some(1), 
                        {(): lz-link(some(1), 
                            {(): nones})})})})})})})

trunc-e = 
  lz-link(some(2), 
    {(): lz-link(some(1), 
        {(): lz-link(some(2), 
            {(): lz-link(some(1), 
                {(): nones})})})})
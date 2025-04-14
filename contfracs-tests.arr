use context shared-gdrive("contfracs-context.arr", "1mr5nHB7DDdOffE_hiovBiEuuBsl_59Gh")
include shared-gdrive("contfracs-definitions.arr", "1fFz3TaWdZgIfNxSGVYx0UQz_GXOBIVsc")

include my-gdrive("contfracs-common.arr")
import take, repeating-stream, threshold, fraction-stream, terminating-stream, repeating-stream-opt, threshold-opt, fraction-stream-opt, cf-phi, cf-phi-opt, cf-e, cf-e-opt, cf-pi-opt
from my-gdrive("contfracs-code.arr")
# END HEADER
# DO NOT CHANGE ANYTHING ABOVE THIS LINE
#
# Write your examples and tests in here. These should not be tests of implementation-specific details (e.g., helper functions).

# Part 1:
#--------------------------------------------------------------------------------------------------
# cf-e and cf-phi tests
check "cf-e property tests":
  take(cf-e, 14) is [list: 2, 1, 2, 1, 1, 4, 1, 1, 6, 1, 1, 8, 1, 1]
  take(cf-e, 1) is [list: 2]
  take(cf-e, 2) is [list: 2, 1]
  take(cf-e, 3) is [list: 2, 1, 2]
  take(cf-e, 0) is empty
end

check "cf-phi property tests":
  take(cf-phi, 14) is [list: 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  take(cf-phi, 1) is [list: 1]
  take(cf-phi, 2) is [list: 1, 1]
  take(cf-phi, 0) is empty
end
#--------------------------------------------------------------------------------------------------
# take tests
check "tests take dealing with a repeating pattern stream":
  take(r123, 3) is [list: 1, 2, 3]
  take(r123, 5) is [list: 1, 2, 3, 1, 2]
  take(cf-e, 10) is [list: 2, 1, 2, 1, 1, 4, 1, 1, 6, 1]
end

check "tests take dealing with a stream of the same elements":
  take(ones, 8) is [list: 1, 1, 1, 1, 1, 1, 1, 1]
  take(twos, 8) is [list: 2, 2, 2, 2, 2, 2, 2, 2]
  take(cf-phi, 3) is [list: 1, 1, 1]
end

check "checks that take returns empty list when n = 0":
  take(ones, 0) is empty
  take(r123, 0) is empty
end
#--------------------------------------------------------------------------------------------------
# repeating-stream-tests
check "checks when repeating-stream is given a non-repeating list":
  take(repeating-stream([list: 1, 2, 3]), 8)
    is [list: 1, 2, 3, 1, 2, 3, 1, 2]
  take(repeating-stream([list: 5, 2, 3, 1]), 9)
    is [list: 5, 2, 3, 1, 5, 2, 3, 1, 5]
  take(repeating-stream([list: 10, 6, 22, 1]), 8)
    is [list: 10, 6, 22, 1, 10, 6, 22, 1]
end
check "checks when repeating-stream is given a list with repeats":
  take(repeating-stream([list: 1, 1, 1]), 6) is [list: 1, 1, 1, 1, 1, 1]
  take(repeating-stream([list: 2, 2]), 6) is [list: 2, 2, 2, 2, 2, 2]
  take(repeating-stream([list: 4, 1, 2, 4, 5, 4]), 8)
    is [list: 4, 1, 2, 4, 5, 4, 4, 1]
end
check "checks when repeating-stream is given a list of one":
  take(repeating-stream([list: 2]), 5) is [list: 2, 2, 2, 2, 2]
  take(repeating-stream([list: 1]), 3) is [list: 1, 1, 1]
end
check "checks when repeating-stream is given a list with negative numbers and/or fractions":
  take(repeating-stream([list: -2, -1, 0, 2]), 5)
    is [list: -2, -1, 0, 2, -2]
  take(repeating-stream([list: 0.5, 9.7, 8.3, -1]), 8)
    is [list: 0.5, 9.7, 8.3, -1, 0.5, 9.7, 8.3, -1]
end
check "tests when repeating-stream is given a long list of numbers":
  long-list = [list: 1, 2, 3, 4, 5, 6, 1, 2, 3, 5, 6, 8, 1, 0, 2, -1, 6, 0.4, 11, 13, 14, 87]
  take(repeating-stream(long-list), 25)
    is [list: 1, 2, 3, 4, 5, 6, 1, 2, 3, 5, 6, 8, 1, 0, 2, -1, 6, 0.4, 11, 13, 14, 87, 1, 2, 3]
end
#--------------------------------------------------------------------------------------------------
# fraction-stream tests
check "tests when fraction-stream is given a stream of repeating numbers":
  take(fraction-stream(twos), 3) is [list: 2, 2 + 1/2, 2 + (1 / (2 + 1/2))]
  take(fraction-stream(ones), 3) is [list: 1, 1 + 1/1, 1 + (1 / (1 + 1/1))]
end
check "tests when fraction-stream is given a stream of a pattern of repeating numbers":
  take(fraction-stream(r123), 4) 
    is [list: 1, 1 + 1/2, 1 + (1 / (2 + 1/3)), 1 + (1 / (2 + (1 / (3 + 1/1))))]
  take(fraction-stream(cf-e), 3)
    is [list: 2, 2 + 1/1, 2 + (1 / (1 + 1/2))]
  take(fraction-stream(cf-e), 4)
    is [list: 2, 2 + 1/1, 2 + (1 / (1 + 1/2)), 2 + (1 / (1 + (1 / (2 + 1/1))))]
  take(fraction-stream(cf-phi), 4)
    is [list: 1, 1 + 1/1, 1 + (1 / (1 + 1/1)), 1 + (1 / (1 + (1 / (1 + 1/1))))]
end
check "tests when fraction-stream is given a stream pattern that starts with a 0":
  starts-0 = repeating-stream([list: 0, 1, 2, 4, 5, 3])
  take(fraction-stream(starts-0), 5)
    is [list: 
    0, 
    0 + 1, 
    0 + (1 / (1 + 1/2)), 
    0 + (1 / (1 + (1 / (2 + (1/4))))), 
    0 + (1 / (1 + (1 / (2 + (1 / (4 + (1/5)))))))]
end
#--------------------------------------------------------------------------------------------------
# threshold-tests
check "threshold tests for when threshold is large, forcing threshold to return the 1st coeff":
  threshold(fraction-stream(cf-e), 20) is 2
  threshold(fraction-stream(cf-e), 2) is 2
  threshold(fraction-stream(cf-phi), 3) is 1
  threshold(fraction-stream(r123), 1) is 1
end

check "testing that when the difference is equal to the thresh, threshold returns the next term":
  threshold(fraction-stream(cf-e), 1) is 2 + 1/1
  threshold(fraction-stream(cf-phi), 1) is 2
  threshold(fraction-stream(r123), 0.5) is 1.5
end

check "general threshold tests":
  threshold(fraction-stream(cf-e), 0.04) is 2.75
  threshold(fraction-stream(cf-phi), 0.07) is 1 + 2/3
end

check "threshold tests for when the stream is already a repeated list of elements":
  threshold(ones, 1) is 1
  threshold(twos, 0.00001) is 2
end
#---------------------------------------------------------------------------------------------
# Part 2:
#-----------------------------------------------------------------------------------------------
# terminating-stream tests:

check "tests terminating-stream when given an empty list":
  take(terminating-stream(empty), 3) is [list: none, none, none]
  take(terminating-stream(empty), 1) is [list: none]
end

check ```terminating stream gets all the elements of the finite list in correct order```:
  take(terminating-stream([list: 1, 2, 3]), 3) is [list: some(1), some(2), some(3)]
  take(terminating-stream([list: 4, 2, 3, 1, 2, 4]), 6) 
    is [list: some(4), some(2), some(3), some(1), some(2), some(4)]
  take(terminating-stream([list: 3]), 1) 
    is [list: some(3)]
end

check ```testing terminating stream: checks the existence of
      infinite nones after representation of the list```:
  take(terminating-stream([list: 1, 2, 3]), 5) is [list: some(1), some(2), some(3), none, none]
  take(terminating-stream([list: 4, 2, 3, 1, 2, 4]), 8) 
    is [list: some(4), some(2), some(3), some(1), some(2), some(4), none, none]
  take(terminating-stream([list: 3]), 10) 
    is [list: some(3), none, none, none, none, none, none, none, none, none]
end
#---------------------------------------------------------------------------------
# repeating-stream-opt tests:
check ```repeating-stream-opt outputs a stream of options
      that preserves the original list's items and order```:
  take(repeating-stream-opt([list: 1, 2, 3]), 3) is [list: some(1), some(2), some(3)]
  take(repeating-stream-opt([list: 4, 1, 2, 4]), 5) 
    is [list: some(4), some(1), some(2), some(4), some(4)]
end
check "repeating-stream-opt handling a list of one":
  take(repeating-stream-opt([list: 2]), 5) 
    is [list: some(2), some(2), some(2), some(2), some(2)]
  take(repeating-stream-opt([list: 1]), 3)
    is [list: some(1), some(1), some(1)]
end

check "repeating-stream-opt handling a list with repeated values": 
  take(repeating-stream-opt([list: 2, 1, 1]), 5)
    is [list: some(2), some(1), some(1), some(2), some(1)]
  take(repeating-stream-opt([list: 3, 3, 3]), 7)
    is [list: some(3), some(3), some(3), some(3), some(3), some(3), some(3)]
end
check "repeating-stream-opt handling a longer list":
  long-list = [list: 1, 2, 3, 4, 5, 6, 1, 2, 3, 5, 6, 8, 1, 0, 2, -1, 6, 0.4, 11, 13, 14, 87]
  take(repeating-stream-opt(long-list), 25)
    is [list: 
    some(1), some(2), some(3), some(4), some(5), some(6), some(1), some(2), 
    some(3), some(5), some(6), some(8), some(1), some(0), some(2), 
    some(-1), some(6), some(0.4), some(11), some(13), some(14), some(87), 
    some(1), some(2), some(3)]
end
#---------------------------------------------------------------------------------
# fraction-stream-opt tests:

check "tests when fraction-stream consumes a stream that contains nones":
  take(fraction-stream-opt(r123-nones), 6)
    is [list: 
    some(1), some(1 + 1/2), some(1 + (1 / (2 + (1/3)))), 
    none, none, none]
  take(fraction-stream-opt(r123-nones), 3)
    is [list: 
    some(1), some(1 + 1/2), some(1 + (1 / (2 + (1/3))))]
end
  
check "tests when fraction-stream-opt is given a stream of repeating numbers":
  take(fraction-stream-opt(twos-opt), 3) 
    is [list: some(2), some(2 + 1/2), some(2 + (1 / (2 + 1/2)))]
  take(fraction-stream-opt(ones-opt), 3) 
    is [list: some(1), some(1 + 1/1), some(1 + (1 / (1 + 1/1)))]
end

check "tests when fraction-stream-opt is given a stream of a pattern of repeating numbers":
  take(fraction-stream-opt(r123-opt), 4) 
    is 
  [list: some(1), some(1 + 1/2), some(1 + (1 / (2 + 1/3))), some(1 + (1 / (2 + (1 / (3 + 1/1)))))]
  take(fraction-stream-opt(cf-e-opt), 3)
    is 
  [list: 
    some(2), 
    some(2 + 1/1), 
    some(2 + (1 / (1 + 1/2)))]
  take(fraction-stream-opt(cf-e-opt), 4)
    is 
  [list: 
    some(2), 
    some(2 + 1/1), 
    some(2 + (1 / (1 + 1/2))), 
    some(2 + (1 / (1 + (1 / (2 + 1/1)))))]
  take(fraction-stream-opt(cf-phi-opt), 4)
    is 
  [list: 
    some(1), 
    some(1 + 1/1),
    some(1 + (1 / (1 + 1/1))),
    some(1 + (1 / (1 + (1 / (1 + 1/1)))))]
  # do cf-e-opt stuff and cf-phi-opt examples. 
end

#---------------------------------------------------------------------------------------------
# threshold-opt tests:

check "threshold-opt tests for when threshold is large, forcing threshold to return the 1st coeff":
  threshold-opt(fraction-stream-opt(cf-e-opt), 20) is 2
  threshold-opt(fraction-stream-opt(cf-e-opt), 2) is 2
  threshold-opt(fraction-stream-opt(cf-phi-opt), 3) is 1
  threshold-opt(fraction-stream-opt(r123-opt), 1) is 1
end
check "testing that when the difference is equal to the thresh, threshold-opt returns the next term":
  threshold-opt(fraction-stream-opt(cf-e-opt), 1) is 2 + 1/1
  threshold-opt(fraction-stream-opt(cf-phi-opt), 1) is 2
  threshold-opt(fraction-stream-opt(r123-opt), 0.5) is 1.5
end

check "general threshold-opt tests":
  threshold-opt(fraction-stream-opt(cf-e-opt), 0.04) is 2.75
  threshold-opt(fraction-stream-opt(cf-phi-opt), 0.07) is 1 + 2/3
end

check "threshold-opt tests for when the stream is already a repeated list of elements":
  threshold-opt(ones-opt, 1) is 1
  threshold-opt(twos-opt, 0.00001) is 2
end

check ```threshold-opt errors for we may run out of values before 
      finding an approximation within the desired threshold```:
  threshold-opt(fraction-stream-opt(r123-nones), 0.02) 
    raises "Threshold too small to approximate"
  threshold-opt(fraction-stream-opt(trunc-e), 0.002)
    raises "Threshold too small to approximate"
end

#------------------------------------------------------------------------------------------------
# tests for cf-phi-opt, cf-e-opt, and cf-pi-opt:

check "testing cf-phi-opt properties": 
  take(cf-phi-opt, 5) is [list: some(1), some(1), some(1), some(1), some(1)]
  take(cf-phi-opt, 1) is [list: some(1)]
end

check "testing cf-e-opt properties": 
  take(cf-e-opt, 10) is 
  [list: some(2), some(1), some(2), some(1), some(1), some(4), some(1), some(1), some(6), some(1)]
  take(cf-e-opt, 20) is 
  [list: 
    some(2), some(1), some(2), some(1), some(1), some(4), some(1), some(1), some(6), some(1), 
    some(1), some(8), some(1), some(1), some(10), some(1), some(1), some(12), some(1), some(1)]
  take(cf-e-opt, 1) is 
  [list: some(2)]
end

check "testing cf-pi-opt properties":  
  take(cf-pi-opt, 5) is [list: some(3), some(7), some(15), some(1), some(292)]
  take(cf-pi-opt, 1) is [list: some(3)]
  take(cf-pi-opt, 4) is [list: some(3), some(7), some(15), some(1)]
  take(cf-pi-opt, 0) is empty
  take(cf-pi-opt-7, 8) 
    is [list: some(3), some(7), some(15), some(1), some(292), some(1), some(1), none]
end

check "first five approximations for pi":
  take(fraction-stream-opt(cf-pi-opt), 5)
    is [list: 
    some(3), 
    some(3 + 1/7), 
    some(3 + (1 / (7 + 1/15))), 
    some(3 + (1 / (7 + (1 / (15 + 1/1))))), 
    some(3 + (1 / (7 + (1 / (15 + (1 / (1 + (1/292))))))))]
end
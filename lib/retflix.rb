#--
# Copyright (c) 2009 by Kyle Wilkinson (kai@wikyd.org).
# All rights reserved.
#
# Permission is granted for use, copying, modification, distribution,
# and distribution of modified versions of this work as long as the above
# copyright notice is included.
#++

[
  'retflix'
].each do |f|
  require File.dirname(__FILE__) + "/retflix/#{f}"
end

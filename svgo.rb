require "awesome_print"

# `echo "asas"`
Dir.glob("./source/assets/img/**.svg").collect do |path|
  # ap path
  system "svgo #{path}"
end

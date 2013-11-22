function grp
  grep --recursive --line-number --ignore-case $argv .
end

function up
  for i in (seq $argv)
    cd ..
  end
end

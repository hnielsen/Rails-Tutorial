desc "Rerun ctags on current project"
task :ctags do
  %x{ctags -f tmp/tags -R --exclude=.git --exclude=log `bundle show rails`/../* }
end


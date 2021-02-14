rvm current 1>/dev/null 2>&1

function __check_rvm --on-variable PWD -d 'Setup rvm on directory change'
  status --is-command-substitution; and return
  if test "$rvm_project_rvmrc" != 0
    set -l cwd $PWD
    while true
      if contains $cwd "" $HOME "/"
        if test "$rvm_project_rvmrc_default" = 1
          rvm default 1>/dev/null 2>&1
        end
        break
      else
        if begin
            test -s ".rvmrc"
            or test -s ".ruby-version"
            or test -s ".ruby-gemset"
            or test -s ".versions.conf"
            or test -s "Gemfile"
          end
          rvm reload 1> /dev/null 2>&1
          rvm rvmrc load 1>/dev/null 2>&1
          break
        else
          set cwd (dirname "$cwd")
        end
      end
    end
    set -e cwd
  end
end

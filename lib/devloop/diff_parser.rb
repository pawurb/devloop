module Devloop
  class DiffParser
    def self.call(diff)
      new.call(diff)
    end

    def call(diff)
      _, results = diff.split("\n").reduce(["", []]) do |(file, results), line|
        if line.start_with?("+++ b/")
          [line[6..-1], results]
        elsif line.start_with?("@@ -")
          line_number = line.match(/@@ -(\d+)/)[1]
          [file, results << "#{relative_path(file)}:#{line_number}"]
        else
          [file, results]
        end
      end
      results
    end

    private

    def relative_path(path)
      path.gsub(project_path, "")
    end

    def project_path
      @project_path ||= Dir.pwd.gsub("#{git_root_path}/", "") + "/"
    end

    def git_root_path
      @git_root_path ||= `git rev-parse --show-toplevel`.strip
    end
  end
end

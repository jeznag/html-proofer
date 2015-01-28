# encoding: utf-8
class HTML::Proofer::Runner

  class Issue
    attr_reader :path, :desc, :status

    def initialize(path, desc, status = -1)
      @path = path
      @desc = desc
      @status = status
    end

    def to_s
      "#{@path}: #{desc}"
    end
  end

  class SortedIssues
    attr_reader :issues

    def initialize(issues, error_sort, logger)
      @issues = issues
      @error_sort = error_sort
      @logger = logger
    end

    def sort_and_report
      case @error_sort
      when :path
        sorted_issues = sort(:path, :desc)
        report(sorted_issues, :path, :desc)
      when :desc
        sorted_issues = sort(:desc, :path)
        report(sorted_issues, :desc, :path)
      when :status
        sorted_issues = sort(:status, :path)
        report(sorted_issues, :status, :path)
      end
    end

    def sort(first_sort, second_sort)
      issues.sort_by { |t| [t.send(first_sort), t.send(second_sort)] }
    end

    def report(sorted_issues, first_report, second_report)
      matcher = nil

      sorted_issues.each do |issue|
        if matcher != issue.send(first_report)
          @logger.log :error, :red, "- #{issue.send(first_report)}"
          matcher = issue.send(first_report)
        end
        if first_report == :status
          @logger.log :error, :red, "  *  #{issue}"
        else
          @logger.log :error, :red, "  *  #{issue.send(second_report)}"
        end
      end
    end
  end
end

module Github
  require 'octokit'

  class Branch
    class << self
      def github_client(user_token)
        Octokit::Client.new(access_token: user_token)
      end

      def get_branch_list(user_token, repo_name)
        client = github_client(user_token)
        github_branches = client.branches(repo_name, per_page: 100)
        branches = []
        github_branches.each do |branch|
          # branches.push({ id: branch[:commit][:sha], name: branch[:name] })
          branches.push([branch[:name], branch[:name]])
        end

        return branches
      end

    end
  end
end

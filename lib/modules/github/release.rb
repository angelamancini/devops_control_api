module Github
  require 'octokit'

  class Release
    class << self
      def github_client(user_token)
        Octokit::Client.new(access_token: user_token)
      end

      def get_release_list(user_token, repo_name)
        client = github_client(user_token)
        github_releases = client.releases(repo_name, sort: :published_at)
        releases = []
        github_releases.each do |release|
          releases.push([release[:tag_name], release[:tag_name]])
        end

        return releases
      end

      def get_release_array(user_token, repo_name)
        client = github_client(user_token)
        github_releases = client.releases(repo_name, sort: :published_at, per_page: 100)
        releases = []
        github_releases.each do |release|
          releases.push(release[:tag_name])
        end

        return releases
      end

      def get_single_release(user_token, repo_name, tag_name)
        client = github_client(user_token)
        releases = client.releases(repo_name)
        @id = nil
        releases.each do |release|
          if release.tag_name == tag_name
            @id = release.id
          end
        end
        url = "https://api.github.com/repos/#{repo_name}/releases/#{@id}"
        release = client.release(url)
      end

      def edit_release(user_token, repo_name, tag_name)
        client = github_client(user_token)
        release = get_single_release(user_token, repo_name, tag_name)
        url = "https://api.github.com/repos/#{repo_name}/releases/#{release.id}"
        client.update_release(url,
                              options = {
                                body: "#{release.body.strip}\nDeployed to Production on #{Time.now.in_time_zone("Eastern Time (US & Canada)").strftime('%m/%d/%y %I:%M%P')}",
                                prerelease: false
                              })
      end

      def get_last_release(user_token, repo_name)
        client = github_client(user_token)
        github_releases = get_release_list(user_token, repo_name)
        if github_releases.blank?
          'N/A'
        else
          client.releases(repo_name).first[:tag_name]
        end

      end

      def create_release(user_token, repo_name, release_notes, old_tag, branch, new_tag)
        client = github_client(user_token)
        release_notes.concat "\nTagged from branch: `#{branch}`"
        begin
          client.create_release(repo_name, new_tag,
                                options = {
                                  tag_name: new_tag,
                                  target_commitish: branch,
                                  name: new_tag,
                                  body: release_notes,
                                  draft: false,
                                  prerelease: true
                                })
          rescue Octokit::UnprocessableEntity
            puts "Can't create!"
          end

        return new_tag
      end

      def update_release(user_token, repo_name,release)
        client = github_client(user_token)
      end
    end
  end
end

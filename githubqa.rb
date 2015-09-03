#!/usr/bin/env ruby

class SrcRepo
	def initialize(root_repo_path, repo_name)
		@root_repo_path = root_repo_path
		@repo_name = repo_name
		@repo_path = "#{root_repo_path}/#{repo_name}"
		@score = 0
		@score_max = 1
	end

	def test_one
		d = Dir.new(@repo_path)
		fns_all = d.map{|fn| fn}
		d.close()

		readme_have = !fns_all.select{ |file| file if file == "README.md" }.empty?
	
		if !readme_have then print "README wasn't found in #{@repo_path}\n" else @score += 1 end

		#travis_fn = fns_all.select { |file| file if file == ".travis.yml" }
		#if not travis_fn then print ".travis.yml wasn't found\n" else @score += 1 end
	end

	def score
		@score
	end

	def self.repo_test_all(root_repos_path)
		repos = []
		d = Dir.new(root_repos_path)
		d.map{|i| i}.select{|fn| fn if not fn =~ /\.$/ }.each do |repo_name|
			repo_path = "#{root_repos_path}/#{repo_name}"
			next if not File.directory?(repo_path)
			r = SrcRepo.new(root_repos_path, repo_name)
			r.test_one()
			if not r then return False else repos.push(r) end
		end
		d.close()
		return repos
	end

	def to_s
		"-- #{@root_repo_path} #{@repo_name} score=#{@score} score_max=#{@score_max}\n"
	end
end

def main(repos_path)
	repos = SrcRepo.repo_test_all(repos_path)

	pts_score_possible = repos.count
	pts_score_actual = 0
	repos.each { |r| pts_score_actual += r.score() }

	print "Possible score    : #{pts_score_possible}\n"
	print "Your current score: #{pts_score_actual}\n"
end

main("/w/repos")

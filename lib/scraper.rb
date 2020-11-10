require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)

    doc = Nokogiri::HTML(URI.open(index_url))

    students = doc.css(".student-card")
    student_infos = students.collect do |student|
      {:name => student.css(".student-name").text, :location => student.css(".student-location").text, :profile_url => student.css("a").first["href"]}
    end
    # binding.pry
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(URI.open(profile_url))

    main = doc.css("div.main-wrapper.profile")

    social_media_links = main.css(".vitals-container").css("a").collect {|link| link["href"]} 


    profile_data = {}

    social_media_links.each do |link|
      if link.include?("twitter")
        profile_data[:twitter] = link

      elsif link.include?("linkedin")
        profile_data[:linkedin] = link 

      elsif link.include?("github")
        profile_data[:github] = link

      else
        profile_data[:blog] = link
      end
    end

    profile_data[:profile_quote] = main.css("div.profile-quote").text
    profile_data[:bio] = main.css("div.description-holder p").text
    # binding.pry


    profile_data
  end 
end 


User.destroy_all

user1 = User.create(name: "test1", email: "test1@example.com", password: "password", password_confirmation: "password")
user2 = User.create(name: "test2", email: "test2@example.com", password: "password", password_confirmation: "password")

["IT", "English", "Communication", "Logic", "Liberal"].each do |general_skill_name|
  user1.general_skills.create(name: general_skill_name)
end

# craete some skills
skills = ["AWS", "MySQL", "ML", "ROR", "TDD", "Serverless", "Linux", "Django", "Python", "GCP", "Ruby", "Go", "Architecture", "Docker", "CI/CD", "Dynamodb", "DDD"]
skills.each do |skill_name|
  user1.general_skills.sample.skills.create(name: skill_name, user: user1)
end

# week
(0..7).each do |i|
  [2,3,4].sample.times do
    Card.create(
      skill: Skill.find_by(name: skills.sample),
      score: [50, 100, 150].sample,
      fact: "これはサンプルです。これはサンプルです。これはサンプルです。これはサンプルです。",
      created_at: i.days.ago,
      updated_at: i.days.ago,
    )
  end
end

# month
(1..4).each do |i|
  [50,80,110].sample.times do
    Card.create(
      skill: Skill.find_by(name: skills.sample),
      score: [50, 100, 150].sample,
      fact: "これはサンプルです。これはサンプルです。これはサンプルです。これはサンプルです。",
      created_at: i.months.ago,
      updated_at: i.months.ago,
    )
  end
end

# year
[[150,1], [120,2], [90,3]].each do |arr|
  arr[0].times do
    Card.create(
      skill: Skill.find_by(name: skills.sample),
      score: [50, 100, 150].sample,
      fact: "これはサンプルです。これはサンプルです。これはサンプルです。これはサンプルです。",
      created_at: arr[1].years.ago,
      updated_at: arr[1].years.ago,
    )
  end
end

# paper
[
  "https://qiita.com/flowerhill/items/b727f91fa5e2756cb046",
  "https://spjai.com/category-classification/",
  "https://medium.com/nyle-engineering-blog/flask%E3%81%A7rest-api%E3%82%92%E4%BD%9C%E3%81%A3%E3%81%A6%E3%81%BF%E3%82%8B-fad8ae1fde5c",
  "https://qiita.com/Azunyan1111/items/9b3d16428d2bcc7c9406",
  "https://qiita.com/ikaro1192/items/9c9af821c23b6ca11fc2",
  "https://www.saintsouth.net/blog/install-python-packages-by-pip-command/"
].each do |url|
  user1.papers.create(url: url)
end

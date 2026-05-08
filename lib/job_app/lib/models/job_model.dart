class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String salary;
  final String type; // Full-time, Part-time, Remote
  final String category;
  final String description;
  final String logoEmoji;
  final bool isSaved;

  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.type,
    required this.category,
    required this.description,
    required this.logoEmoji,
    this.isSaved = false,
  });

  Job copyWith({bool? isSaved}) => Job(
        id: id,
        title: title,
        company: company,
        location: location,
        salary: salary,
        type: type,
        category: category,
        description: description,
        logoEmoji: logoEmoji,
        isSaved: isSaved ?? this.isSaved,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'company': company,
        'location': location,
        'salary': salary,
        'type': type,
        'category': category,
        'description': description,
        'logoEmoji': logoEmoji,
        'isSaved': isSaved,
      };
}

final List<Job> sampleJobs = [
  const Job(
    id: '1',
    title: 'Senior Flutter Developer',
    company: 'TechNova Inc.',
    location: 'Remote',
    salary: '\$5,000 - \$8,000/mo',
    type: 'Remote',
    category: 'Technology',
    description:
        'We are looking for an experienced Flutter developer to join our team. You will be building cross-platform mobile applications with a focus on performance and user experience.',
    logoEmoji: '💙',
  ),
  const Job(
    id: '2',
    title: 'UI/UX Designer',
    company: 'PixelCraft Studio',
    location: 'New York, USA',
    salary: '\$4,000 - \$6,500/mo',
    type: 'Full-time',
    category: 'Design',
    description:
        'Join our creative team to design stunning user interfaces for our suite of consumer products. Strong portfolio required.',
    logoEmoji: '🎨',
  ),
  const Job(
    id: '3',
    title: 'Product Manager',
    company: 'GrowthLab',
    location: 'San Francisco, USA',
    salary: '\$7,000 - \$10,000/mo',
    type: 'Full-time',
    category: 'Management',
    description:
        'Lead product strategy and roadmap for our B2B SaaS platform. 3+ years of PM experience required.',
    logoEmoji: '📊',
  ),
  const Job(
    id: '4',
    title: 'Backend Engineer',
    company: 'CloudBase',
    location: 'London, UK',
    salary: '\$4,500 - \$7,000/mo',
    type: 'Hybrid',
    category: 'Technology',
    description:
        'Build scalable microservices using Node.js and Go. Experience with Kubernetes and AWS is a plus.',
    logoEmoji: '⚙️',
  ),
  const Job(
    id: '5',
    title: 'Data Scientist',
    company: 'InsightAI',
    location: 'Remote',
    salary: '\$6,000 - \$9,000/mo',
    type: 'Remote',
    category: 'Data',
    description:
        'Apply machine learning models to real-world datasets. Python, TensorFlow, and SQL expertise required.',
    logoEmoji: '🤖',
  ),
  const Job(
    id: '6',
    title: 'Marketing Specialist',
    company: 'BrandWave',
    location: 'Austin, USA',
    salary: '\$3,000 - \$5,000/mo',
    type: 'Full-time',
    category: 'Marketing',
    description:
        'Drive digital marketing campaigns across social media and email. Google Ads certification preferred.',
    logoEmoji: '📣',
  ),
];

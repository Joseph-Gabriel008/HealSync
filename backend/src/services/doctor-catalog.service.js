const seedDoctors = [
  {
    id: '1',
    name: 'Dr. John Mathew',
    specialization: 'Cardiologist',
    category: 'Cardiology',
    experience: '10 years',
    rating: 4.5,
    image: 'doctor1.jpg',
  },
  {
    id: '2',
    name: 'Dr. Asha Menon',
    specialization: 'Dermatologist',
    category: 'Dermatology',
    experience: '8 years',
    rating: 4.7,
    image: 'doctor2.jpg',
  },
  {
    id: '3',
    name: 'Dr. Vivek Rao',
    specialization: 'General Physician',
    category: 'General',
    experience: '12 years',
    rating: 4.4,
    image: 'doctor3.jpg',
  },
  {
    id: '4',
    name: 'Dr. Priya Nair',
    specialization: 'Pediatrician',
    category: 'Pediatrics',
    experience: '9 years',
    rating: 4.8,
    image: 'doctor4.jpg',
  },
  {
    id: '5',
    name: 'Dr. Sameer Khan',
    specialization: 'Cardiologist',
    category: 'Cardiology',
    experience: '15 years',
    rating: 4.9,
    image: 'doctor5.jpg',
  },
];

function listDoctors({ category, search } = {}) {
  let doctors = [...seedDoctors];

  if (category && category.trim() !== '' && category !== 'All') {
    const normalizedCategory = category.trim().toLowerCase();
    doctors = doctors.filter((doctor) => {
      return doctor.category.toLowerCase() == normalizedCategory;
    });
  }

  if (search && search.trim() !== '') {
    const normalizedSearch = search.trim().toLowerCase();
    doctors = doctors.filter((doctor) => {
      return doctor.name.toLowerCase().includes(normalizedSearch);
    });
  }

  return doctors;
}

module.exports = { listDoctors };

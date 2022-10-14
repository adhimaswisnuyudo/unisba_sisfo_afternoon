class ActiveUser {
  int? npm;
  String? noTest;
  String? nik;
  String? nisn;
  int? prodiId;
  int? idKonsentrasi;
  int? angkatan;
  String? jaket;
  String? toga;
  String? nama;
  String? tempatLahir;
  String? tanggalLahir;
  String? jenisKelamin;
  String? agama;
  String? golDarah;
  String? alamat;
  int? kewarganegaraanId;
  int? negara;
  String? provinsi;
  String? kota;
  String? kecamatan;
  String? kelurahan;
  String? kodePos;
  String? telepon;
  String? email;
  String? emailUnisba;
  String? hobi;
  String? biayaKuliah;
  String? nikDosenWali;
  String? dosenWali;
  String? foto;
  int? kategoriFaskesId;
  String? namaFaskes;
  String? createdAt;
  String? updatedAt;

  ActiveUser(
      {this.npm,
      this.noTest,
      this.nik,
      this.nisn,
      this.prodiId,
      this.idKonsentrasi,
      this.angkatan,
      this.jaket,
      this.toga,
      this.nama,
      this.tempatLahir,
      this.tanggalLahir,
      this.jenisKelamin,
      this.agama,
      this.golDarah,
      this.alamat,
      this.kewarganegaraanId,
      this.negara,
      this.provinsi,
      this.kota,
      this.kecamatan,
      this.kelurahan,
      this.kodePos,
      this.telepon,
      this.email,
      this.emailUnisba,
      this.hobi,
      this.biayaKuliah,
      this.nikDosenWali,
      this.dosenWali,
      this.foto,
      this.kategoriFaskesId,
      this.namaFaskes,
      this.createdAt,
      this.updatedAt});

  ActiveUser.fromJson(Map<String, dynamic> json) {
    npm = json['npm'];
    noTest = json['no_test'];
    nik = json['nik'];
    nisn = json['nisn'];
    prodiId = json['prodi_id'];
    idKonsentrasi = json['id_konsentrasi'];
    angkatan = json['angkatan'];
    jaket = json['jaket'];
    toga = json['toga'];
    nama = json['nama'];
    tempatLahir = json['tempat_lahir'];
    tanggalLahir = json['tanggal_lahir'];
    jenisKelamin = json['jenis_kelamin'];
    agama = json['agama'];
    golDarah = json['gol_darah'];
    alamat = json['alamat'];
    kewarganegaraanId = json['kewarganegaraan_id'];
    negara = json['negara'];
    provinsi = json['provinsi'];
    kota = json['kota'];
    kecamatan = json['kecamatan'];
    kelurahan = json['kelurahan'];
    kodePos = json['kode_pos'];
    telepon = json['telepon'];
    email = json['email'];
    emailUnisba = json['email_unisba'];
    hobi = json['hobi'];
    biayaKuliah = json['biaya_kuliah'];
    nikDosenWali = json['nik_dosen_wali'];
    dosenWali = json['dosen_wali'];
    foto = json['foto'];
    kategoriFaskesId = json['kategori_faskes_id'];
    namaFaskes = json['nama_faskes'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['npm'] = npm;
    data['no_test'] = noTest;
    data['nik'] = nik;
    data['nisn'] = nisn;
    data['prodi_id'] = prodiId;
    data['id_konsentrasi'] = idKonsentrasi;
    data['angkatan'] = angkatan;
    data['jaket'] = jaket;
    data['toga'] = toga;
    data['nama'] = nama;
    data['tempat_lahir'] = tempatLahir;
    data['tanggal_lahir'] = tanggalLahir;
    data['jenis_kelamin'] = jenisKelamin;
    data['agama'] = agama;
    data['gol_darah'] = golDarah;
    data['alamat'] = alamat;
    data['kewarganegaraan_id'] = kewarganegaraanId;
    data['negara'] = negara;
    data['provinsi'] = provinsi;
    data['kota'] = kota;
    data['kecamatan'] = kecamatan;
    data['kelurahan'] = kelurahan;
    data['kode_pos'] = kodePos;
    data['telepon'] = telepon;
    data['email'] = email;
    data['email_unisba'] = emailUnisba;
    data['hobi'] = hobi;
    data['biaya_kuliah'] = biayaKuliah;
    data['nik_dosen_wali'] = nikDosenWali;
    data['dosen_wali'] = dosenWali;
    data['foto'] = foto;
    data['kategori_faskes_id'] = kategoriFaskesId;
    data['nama_faskes'] = namaFaskes;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

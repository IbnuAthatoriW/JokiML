@extends('layouts.app')

@section('content')

<h2>Tambah Jasa</h2>

<div class="card p-4 shadow">

<form action="/jasa" method="POST">

@csrf

<div class="mb-3">

<label>Nama Jasa</label>

<input type="text"
name="nama_jasa"
class="form-control">

</div>

<div class="mb-3">

<label>Deskripsi</label>

<textarea
name="deskripsi"
class="form-control"></textarea>

</div>

<div class="mb-3">

<label>Harga</label>

<input type="number"
name="harga"
class="form-control">

</div>

<button class="btn btn-primary">
Simpan
</button>

</form>

</div>

@endsection
@extends('layout.app')

@section('content')

<h2>Buat Order</h2>

<div class="card p-4 shadow">

    <form action="/order" method="POST">

        @csrf

        <div class="mb-3">

            <label>Pilih Jasa</label>

            <select name="jasa_id"
                class="form-control">

                @foreach($jasas as $jasa)

                <option value="{{ $jasa->id }}">

                    {{ $jasa->nama_jasa }}

                </option>

                @endforeach

            </select>

        </div>

        <button class="btn btn-success">

            Pesan Sekarang

        </button>

    </form>

</div>

@endsection
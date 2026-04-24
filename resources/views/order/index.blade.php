@extends('layouts.app')

@section('content')

<h2>Data Order</h2>

<a href="/order/create">Tambah Order</a>

<table border="1">
    <tr>
        <th>ID</th>
        <th>Jasa</th>
        <th>Status</th>
    </tr>

    @foreach($orders as $order)

    <tr>
        <td>{{ $order->id }}</td>
        <td>{{ $order->jasa->nama_jasa }}</td>
        <td>{{ $order->status }}</td>
    </tr>

    @endforeach

</table>

@endsection
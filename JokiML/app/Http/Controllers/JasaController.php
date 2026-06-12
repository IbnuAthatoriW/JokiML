<?php

namespace App\Http\Controllers;

use App\Models\Jasa;
use Illuminate\Http\Request;

class JasaController extends Controller
{
    public function index()
    {
        $jasas = Jasa::all();
        return view('jasa.index', compact('jasas'));
    }

    public function create()
    {
        return view('jasa.create');
    }

    public function store(Request $request)
    {
        Jasa::create($request->all());
        return redirect('/jasa');
    }

    public function destroy($id)
    {
        Jasa::destroy($id);
        return redirect('/jasa');
    }
}

<?php

namespace App\Http\Controllers;


use App\Models\Score;
use Illuminate\Http\Request;


class ScoreController extends Controller
{
public function index()
{
$scores = Score::orderByDesc('score')->get();
return view('scores', compact('scores'));
}


public function store(Request $request)
{
$request->validate([
'name' => 'required|string',
'score' => 'required|integer'
]);


Score::create($request->only('name', 'score'));


return redirect()->back();
}
}

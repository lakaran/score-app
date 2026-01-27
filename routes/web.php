<?php

use App\Http\Controllers\ScoreController;
use Illuminate\Support\Facades\Route;

// Forçamos a limpeza de qualquer cache anterior definindo a rota explicitamente
Route::get('/', [ScoreController::class, 'index']); #->name('scores.index');
Route::post('/scores', [ScoreController::class, 'store'])->name('scores.store');

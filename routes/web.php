<?php

use App\Http\Controllers\ScoreController;


Route::get('/', [ScoreController::class, 'index']);
Route::post('/scores', [ScoreController::class, 'store'])->name('scores.store');

Route::get('/', function () {
    return 'Laravel está ONLINE 🚀';
});

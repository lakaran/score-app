<!DOCTYPE html>
<html lang="pt">
<head>
<meta charset="UTF-8">
<title>Pontuações</title>
</head>
<body>
<h1>Inserir Pontuação</h1>


<form method="POST" action="{{ route('scores.store') }}">
@csrf
<label>Nome</label><br>
<input type="text" name="name" required><br><br>


<label>Pontuação</label><br>
<input type="number" name="score" required><br><br>


<button type="submit">Guardar</button>
</form>


<hr>


<h2>Ranking</h2>
<ul>
@foreach($scores as $score)
<li>{{ $score->name }} - {{ $score->score }}</li>
@endforeach
</ul>
</body>
</html>
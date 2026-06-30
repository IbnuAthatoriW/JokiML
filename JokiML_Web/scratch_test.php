<?php
require 'vendor/autoload.php';
$app = require_once 'bootstrap/app.php';

use App\Models\Order;
use App\Models\User;

$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

$orders = Order::latest();
$orders->where('user_id', 3);
$sql = $orders->toSql();
echo "SQL: " . $sql . "\n";
echo "Count: " . count($orders->get()) . "\n";

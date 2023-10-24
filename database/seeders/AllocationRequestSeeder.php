<?php

namespace Database\Seeders;

use App\Models\AllocationRequest;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class AllocationRequestSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        AllocationRequest::factory(100)->create();
    }
}

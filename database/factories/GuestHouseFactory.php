<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\GuestHouse>
 */
class GuestHouseFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'title'=>'Guest House '.fake()->streetName(),
            'gps_location'=>json_encode(fake()->localCoordinates()),
            'address'=>fake()->address()
        ];
    }
}

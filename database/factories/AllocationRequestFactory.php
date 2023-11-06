<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\AllocationRequest>
 */
class AllocationRequestFactory extends Factory
{
    /**
     *
     * $table->id();
    $table->unsignedBigInteger('user_id');
    $table->unsignedBigInteger('guest_house_id');
    $table->unsignedBigInteger('room_id')->nullable();
    $table->string('status')->nullable();
    $table->dateTime("boarding_date");
    $table->dateTime("departure_date");
    $table->dateTime('extension_request_date')->nullable();
    $table->timestamps();
     */
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id'=>random_int(1,100),
            'guest_house_id'=>random_int(1,2),
            'room_id'=>random_int(1,10),
            'status'=>(['approved','rejected','pending','cancelled','expired'])[random_int(0,4)],
            'room_type'=>(['AC','NON-AC'])[random_int(0,1)],
            'booking_type'=>(['PERSONAL','OFFICIAL'])[random_int(0,1)],
            'guest_count'=>random_int(1,5),
            'boarding_date'=>fake()->dateTime(),
            'departure_date'=>fake()->dateTime,
        ];
    }
}

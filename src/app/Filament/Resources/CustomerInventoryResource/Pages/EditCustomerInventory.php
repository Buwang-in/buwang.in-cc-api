<?php

namespace App\Filament\Resources\CustomerInventoryResource\Pages;

use App\Filament\Resources\CustomerInventoryResource;
use Filament\Pages\Actions;
use Filament\Resources\Pages\EditRecord;

class EditCustomerInventory extends EditRecord
{
    protected static string $resource = CustomerInventoryResource::class;

    protected function getActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}
